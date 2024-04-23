//
//  DateFormatter + Extensions.swift
//  Artlier
//
//  Created by 김병엽 on 2024/04/23.
//

import Foundation

extension DateFormatter {
    
    static var krDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        return formatter
    }
    
    static func getDateFormatter() -> DateFormatter {
        return krDateFormatter
    }
}
