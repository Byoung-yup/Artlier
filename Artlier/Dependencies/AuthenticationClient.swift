//
//  AuthenticationClient.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

struct AuthenticationClient {
    var listenAuthState: @Sendable () async throws -> AsyncThrowingStream<String?, Error>
    var createUser: (_ email: String, _ password: String) async throws -> Void
    
    init(
        listenAuthState: @escaping @Sendable () async throws -> AsyncThrowingStream<String?, Error>,
        createUser: @escaping (_ email: String, _ password: String) async throws -> Void
    ) {
        self.listenAuthState = listenAuthState
        self.createUser = createUser
    }
}

extension AuthenticationClient: DependencyKey {
    static let liveValue: Self = Self (
        listenAuthState: {
            AsyncThrowingStream { continuation in
                let listenerHandle = Auth.auth()
                    .addStateDidChangeListener { auth, user in
                        if let user {
                            print("user exists")
                            continuation.yield(with: .success(user.uid))
                        } else {
                            print("user not exists")
                            continuation.yield(with: .failure(AppError.FirebaseAuthError))
                        }
                    }
                
                continuation.onTermination = { _ in
                    Auth.auth().removeStateDidChangeListener(listenerHandle)
                }
            }
        },
        createUser: { (email, password) in
            do {
                try await Auth.auth().createUser(withEmail: email, password: password)
            } catch let error {
                print("createUser error", error.localizedDescription)
                throw AppError.FirebaseAuthError
            }
        }
    )
}

extension DependencyValues {
    var authenticationClient: AuthenticationClient {
        get { self[AuthenticationClient.self] }
        set { self[AuthenticationClient.self] = newValue }
    }
}
