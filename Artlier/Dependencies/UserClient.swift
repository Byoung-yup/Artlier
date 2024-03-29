//
//  UserClient.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/20.
//

import ComposableArchitecture
import FirebaseDatabase
import FirebaseStorage

struct UserClient {
    var existUser: @Sendable (_ userId: String) async throws -> Bool
    var createUser: @Sendable (_ id: String, _ nickname: String, _ imageData: Data) async throws -> Bool
    
    init(
        existUser: @escaping @Sendable (_ userId: String) async throws -> Bool,
        createUser: @escaping @Sendable (_ id: String, _ nickname: String, _ imageData: Data) async throws -> Bool
    ) {
        self.existUser = existUser
        self.createUser = createUser
    }
}

extension UserClient: DependencyKey {
    static let dbRef = Database.database().reference()
    static let storageRef = Storage.storage().reference()
    
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
                    imageUrl: imageUrl
                )
                
                let encoded = try JSONEncoder().encode(appUser)
                let data = try JSONSerialization.jsonObject(with: encoded, options: .fragmentsAllowed)
                
                try await dbRef.child(path).setValue(data)
                return true
            } catch let error {
                print("createUser Error", error.localizedDescription)
                throw error
            }
        }
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
