//
//  UserClient.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/20.
//

import ComposableArchitecture
import FirebaseDatabase
import FirebaseStorage
import Combine

struct UserClient {
    var existUser: @Sendable (_ userId: String) async throws -> Bool
    var createUser: @Sendable (_ id: String, _ nickname: String, _ imageData: Data) async throws -> Bool
    var fetchUser: (_ id: String) async throws -> Bool
    var currentUser: @Sendable () -> AppUser
    
    init(
        existUser: @escaping @Sendable (_ userId: String) async throws -> Bool,
        createUser: @escaping @Sendable (_ id: String, _ nickname: String, _ imageData: Data) async throws -> Bool,
        fetchUser: @escaping (_ id: String) async throws -> Bool,
        currentUser: @escaping @Sendable () -> AppUser
    ) {
        self.existUser = existUser
        self.createUser = createUser
        self.fetchUser = fetchUser
        self.currentUser = currentUser
    }
}

extension UserClient: DependencyKey {
    static let dbRef = Database.database().reference()
    static let storageRef = Storage.storage().reference()
    
    static let currentUser: CurrentValueSubject<AppUser, Never> = .init(AppUser.mockData)
    
    static let liveValue: Self = Self(
        existUser: { (userId) in
            do {
                let path = Constant.getPath(key: DBKey.Users, path: userId)
                
                let snapshot = try await dbRef.child(path).getData()
                guard snapshot.exists() else {
                    print("not Found User")
                    return false
                }
                print("Find User")
                return true
            } catch {
                print("error existUser")
                throw AppError.FirebaseError
            }
        },
        createUser: { (id, nickname, imageData) in
            do {
                let path = Constant.getPath(key: DBKey.Users, path: id)
                
                let (snapshot, _) = await dbRef.child(DBKey.Users).queryOrdered(byChild: "nickname").queryEqual(toValue: nickname).observeSingleEventAndPreviousSiblingKey(of: .value)
                guard !(snapshot.exists()) else {
                    print("exist nickname")
                    throw AppError.FirebaseExistDataError
                }
                
                print("not exist nickname")
                let ref = storageRef.child(path + "/image.jpeg")
                _ = try await ref.putDataAsync(imageData)
                let imageUrl = try await ref.downloadURL().absoluteString
                
                let appUser = AppUser(
                    id: id,
                    nickname: nickname,
                    imageUrl: imageUrl,
                    followers: [],
                    following: [],
                    myAlbums: []
                )
                
                let encoded = try JSONEncoder().encode(appUser)
                let data = try JSONSerialization.jsonObject(with: encoded, options: .fragmentsAllowed)
                
                try await dbRef.child(path).setValue(data)
                return true
            } catch let error {
                print("createUser Error", error.localizedDescription)
                throw error
            }
        },
        fetchUser: { (userId) in
            do {
                let path = Constant.getPath(key: DBKey.Users, path: userId)
                
                let snapshot = try await dbRef.child(path).getData()
                guard snapshot.exists() else {
                    print("not Found User")
                    return false
                }
                print("Find User")
                let appUser = try snapshot.data(as: AppUser.self)
                UserClient.currentUser.send(appUser)
                return true
            } catch let error {
                print("error fetchUser", error.localizedDescription)
                throw AppError.FirebaseError
            }
        },
        currentUser: {
            return UserClient.currentUser.value
        }
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
