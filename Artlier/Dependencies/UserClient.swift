//
//  UserClient.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/20.
//

import ComposableArchitecture
import FirebaseDatabase

struct UserClient {
    var existUser: @Sendable (_ userId: String) async throws -> Bool
    
    init(
        existUser: @escaping @Sendable (_ userId: String) async throws -> Bool
    ) {
        self.existUser = existUser
    }
}

extension UserClient: DependencyKey {
    static let ref = Database.database().reference()
    
    static let liveValue: Self = Self(
        existUser: { (userId) in
            do {
                let path = Constant.getPath(key: DBKey.Users, path: userId)
                
                let snapshot = try await ref.child(path).getData()
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
        }
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
