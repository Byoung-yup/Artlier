//
//  Date + Extensions.swift
//  Artlier
//
//  Created by 김병엽 on 2024/04/04.
//

import Foundation

extension Date {
    
    func dateformatter() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy년 MM월"
        dateformatter.locale = Locale(identifier: "ko_kr")
        return dateformatter.string(from: self)
    }
}
