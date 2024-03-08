//
//  Underline.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/08.
//

import Foundation
import SwiftUI

struct UnderlineTextField: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            content
                .autocapitalization(.none)
                .foregroundStyle(.black)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(.black)
                .frame(height: 2)
        }
    }
}
