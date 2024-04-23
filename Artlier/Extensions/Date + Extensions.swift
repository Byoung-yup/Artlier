//
//  Date + Extensions.swift
//  Artlier
//
//  Created by 김병엽 on 2024/04/04.
//

import Foundation

extension Date {
    
    func toFormattedString(_ dateFormat: String = "yyyy년 MM월") -> String {
        let dateFormatter = DateFormatter.getDateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
