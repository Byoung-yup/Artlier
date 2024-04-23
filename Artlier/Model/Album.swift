//
//  Album.swift
//  Artlier
//
//  Created by 김병엽 on 2024/04/23.
//

import Foundation

struct Album: Codable {
    let id: String
    let userId: String
    let nickname: String
    let profileImageUrl: String
    let title: String
    let content: String
    let date: String
    var albumImageUrls: [String] = []
    
    enum CodingKeys: CodingKey {
        case id
        case userId
        case nickname
        case profileImageUrl
        case title
        case content
        case date
        case albumImageUrls
    }
}
