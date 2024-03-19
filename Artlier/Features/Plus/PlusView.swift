//
//  PlusView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import SwiftUI
import ComposableArchitecture

struct PlusView: View {
    let store: StoreOf<PlusFeature>
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea(.all)
            
            
        }
    }
}

#Preview {
    PlusView(
        store: Store(
            initialState: PlusFeature.State()
        ) {
            PlusFeature()
        }
    )
}
