//
//  Constant.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import Foundation

enum Constant { }

typealias DBKey = Constant.DBKey

extension Constant {
    struct DBKey {
        static let Users = "Users"
        static let Albums = "Albums"
    }
    
    static func getPath(key: String, path: String?) -> String {
        if let path {
            return "\(key)/\(path)"
        } else {
            return key
        }
    }
}
