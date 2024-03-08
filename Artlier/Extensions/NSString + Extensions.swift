//
//  String + Extensions.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/09.
//

import Foundation

extension NSString {
    
    // MARK: email Validation
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    // MARK: password Validation
    func isValidPassword() -> Bool {
        let psRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,12}"
        let psPredicate = NSPredicate(format: "SELF MATCHES %@", psRegex)
        return psPredicate.evaluate(with: self)
    }
}
