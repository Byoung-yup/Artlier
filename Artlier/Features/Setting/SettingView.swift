//
//  SettingView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    let store: StoreOf<SettingFeature>
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea(.all)
            
            
        }
    }
}

#Preview {
    SettingView(
        store: Store(
            initialState: SettingFeature.State()
        ) {
            SettingFeature()
        }
    )
}
