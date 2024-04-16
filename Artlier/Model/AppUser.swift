//
//  AppUser.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/29.
//

import Foundation

struct AppUser: Codable {
    let id: String
    let nickname: String
    let imageUrl: String
    let followers: [String]?
    let following: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case imageUrl
        case followers
        case following
    }
}

extension AppUser {
    // mock
    static var mockData: Self {
        return Self(id: "test_id", nickname: "test_nickname", imageUrl: "test_url", followers: [], following: [])
    }
}
