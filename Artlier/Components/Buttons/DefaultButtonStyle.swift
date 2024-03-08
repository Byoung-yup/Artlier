//
//  DefaultButtonStyle.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/08.
//

import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    
    let textColor: Color
    
    init(textColor: Color) {
        self.textColor = textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(.black)
            }
    }
}
