//
//  MessageView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import SwiftUI
import ComposableArchitecture

struct MessageView: View {
    let store: StoreOf<MessageFeature>
    
    var body: some View {
        ZStack {
            Color.orange
                .ignoresSafeArea(.all)
            
            
        }
    }
}

#Preview {
    MessageView(
        store: Store(
            initialState: MessageFeature.State()
        ) {
            MessageFeature()
        }
    )
}
