//
//  AuthenticatedView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import SwiftUI
import ComposableArchitecture

struct AuthenticatedView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        contentView
            .task { await store.send(.view(.task)).finish() }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch store.phase {
        case .notRequested:
            PlaceholderView()
        case .loading:
            LoadingView()
        case .success:
            EmptyView()
        case .fail:
            IntroView(store: store.scope(state: \.intro, action: \.intro))
        }
    }
}

#Preview {
    AuthenticatedView(
        store: Store(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
    )
}
