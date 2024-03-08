//
//  Hidden.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/09.
//

import SwiftUI

struct HideViewModifier: ViewModifier {
    let isHidden: Bool
    
    @ViewBuilder func body(content: Content) -> some View {
        if isHidden {
            EmptyView()
        } else {
            content
        }
    }
}
