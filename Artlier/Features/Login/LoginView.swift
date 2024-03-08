//
//  LoginView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/08.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LoginView(
        store: Store(
            initialState: LoginFeature.State()
        ) {
            LoginFeature()
        }
    )
}
