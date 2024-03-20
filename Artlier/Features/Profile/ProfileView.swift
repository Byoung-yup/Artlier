//
//  PlusView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea(.all)
            
            
        }
    }
}

#Preview {
    ProfileView(
        store: Store(
            initialState: ProfileFeature.State()
        ) {
            ProfileFeature()
        }
    )
}
