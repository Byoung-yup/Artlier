//
//  Error.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import FirebaseAuth

enum AppError: Error {
    // MARK: firebase Common
    case FirebaseError
    // MARK: firebase Auth Common
    case FirebaseAuthError
    
    // MARK: firebase Auth
    case FirebaseinvalidPasswordError
    case FirebasecredentialError
    
    static func mapError(_ error: NSError) -> Self {
        switch error.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return .FirebaseinvalidPasswordError
            
        default:
            return .FirebaseAuthError
        }
    }
}
