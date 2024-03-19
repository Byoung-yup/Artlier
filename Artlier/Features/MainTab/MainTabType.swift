//
//  MainTabType.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/19.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case contact
    case message
    case home
    case plus
    case setting
    
    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_selected" : "\(rawValue)"
    }
}
