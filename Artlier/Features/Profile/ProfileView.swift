//
//  PlusView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: ProfileFeature.self)
struct ProfileView: View {
    @Bindable var store: StoreOf<ProfileFeature>
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            
            
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                send(.plusButtonTapped)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 21)
            .padding(.vertical, 21)
        }
        .navigationTitle("Profile")
        .navigationBarTitleTextColor(.black)
        .navigationBarTitleDisplayMode(.large)
        .fullScreenCover(
            item: $store.scope(
                state: \.destination?.content,
                action: \.destination.content
            )
        ) { store in
            PlusContentView(store: store)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(
            store: Store(
                initialState: ProfileFeature.State()
            ) {
                ProfileFeature()
            }
        )
    }
}
