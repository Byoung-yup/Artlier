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
    var signIn: @Sendable (_ email: String, _ password: String) async throws -> String
    
    init(
        listenAuthState: @escaping @Sendable () async throws -> AsyncThrowingStream<String?, Error>,
        createUser: @escaping (_ email: String, _ password: String) async throws -> Void,
        signIn: @escaping @Sendable(_ email: String, _ password: String) async throws -> String
    ) {
        self.listenAuthState = listenAuthState
        self.createUser = createUser
        self.signIn = signIn
    }
}

extension AuthenticationClient: DependencyKey {
    static let liveValue: Self = Self (
        listenAuthState: {
            AsyncThrowingStream { continuation in
                let listenerHandle = Auth.auth()
                    .addStateDidChangeListener { auth, user in
                        if let user {
                            print("exists userId")
                            continuation.yield(with: .success(user.uid))
                        } else {
                            print("not exists userId")
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
        },
        signIn: {
             (email, password) in
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                let user = result.user
                return user.uid
            } catch let error as NSError {
                print("signIn error", error.localizedDescription)
                throw AppError.mapError(error)
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
