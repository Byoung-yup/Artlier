//
//  MainTabView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: MainTabFeature.self)
struct MainTabView: View {
    let store: StoreOf<MainTabFeature>
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        switch store.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear { send(.onAppear) }
        case .loading:
            LoadingView()
        case .success:
            MainView(store: store)
        case .fail:
            if let store = store.scope(state: \.account, action: \.account) {
                AccountView(store: store)
            }
        }
    }
}

@ViewAction(for: MainTabFeature.self)
fileprivate struct MainView: View {
    let store: StoreOf<MainTabFeature>
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
//        ZStack {
            TabView(selection: $selectedTab) {
                ForEach(MainTabType.allCases, id: \.self) { tab in
                    Group {
                        switch tab {
                        case .contact:
                            ContactView(store: store.scope(state: \.contact, action: \.contact))
                                
                        case .message:
                            MessageView(store: store.scope(state: \.message, action: \.message))
                        case .home:
                            HomeView(store: store.scope(state: \.home, action: \.home))
                                
                        case .plus:
                            ProfileView(store: store.scope(state: \.profile, action: \.profile))
                        case .setting:
                            SettingView(store: store.scope(state: \.setting, action: \.setting))
                        }
                    }
                    .tabItem {
                        Image(tab.imageName(selected: selectedTab == tab))
                    }
                    .tag(tab)
                }
            }
            .tint(.black)
            
            
//            SeperatorLineView()
//        }
//        .overlay(alignment: .bottom) {
//            Rectangle()
//                .fill(
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                )
//                .frame(height: 10)
//                .padding(.bottom, 60)
//        }
    }
    
    init(store: StoreOf<MainTabFeature>) {
        self.store = store
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
    }
}

fileprivate struct SeperatorLineView: View {
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 10)
                .padding(.bottom, 60)
        }
    }
}

#Preview {
    MainTabView(
        store: Store(
            initialState: MainTabFeature.State(userId: "")
        ) {
            MainTabFeature()
        }
    )
}
