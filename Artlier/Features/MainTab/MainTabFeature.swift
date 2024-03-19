//
//  MainTabFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import ComposableArchitecture

enum Tab: Hashable {
    case contact
    case message
    case home
    case plus
    case setting
}

@Reducer
struct MainTabFeature {
    @ObservableState
    struct State {
//        var selectedTab: Tab = .home
//        var destination: Destination.State
        
        var contact: ContactFeature.State = .init()
        var message: MessageFeature.State = .init()
        var home: HomeFeature.State = .init()
        var plus: PlusFeature.State = .init()
        var setting: SettingFeature.State = .init()
        
        var phase: Phase = .success
    }
    
    enum Action: ViewAction {
        case view(View)
        
        case contact(ContactFeature.Action)
        case message(MessageFeature.Action)
        case home(HomeFeature.Action)
        case plus(PlusFeature.Action)
        case setting(SettingFeature.Action)
//        case destination(Destination.Action)
//        case binding(BindingAction<State>)
        
        enum View {
            case tabSelected(Tab)
        }
    }
    
    var body: some ReducerOf<Self> {
//        BindingReducer()
        Scope(state: \.contact, action: \.contact) {
            ContactFeature()
        }
        Scope(state: \.message, action: \.message) {
            MessageFeature()
        }
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.plus, action: \.plus) {
            PlusFeature()
        }
        Scope(state: \.setting, action: \.setting) {
            SettingFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case let .tabSelected(tabItem):
//                    switch tabItem {
//                    case .contact:
//                        state.destination = .contact(ContactFeature.State())
//                    case .message:
//                        state.destination = .message(MessageFeature.State())
//                    case .home:
//                        state.destination = .home(HomeFeature.State())
//                    case .plus:
//                        state.destination = .plus(PlusFeature.State())
//                    case .setting:
//                        state.destination = .setting(SettingFeature.State())
//                    }
                    return .none
                }
                
//            case .binding(\.selectedTab):
//                switch state.selectedTab {
//                case .contact:
//                    state.destination = .contact(ContactFeature.State())
//                case .message:
//                    state.destination = .message(MessageFeature.State())
//                case .home:
//                    state.destination = .home(HomeFeature.State())
//                case .plus:
//                    state.destination = .plus(PlusFeature.State())
//                case .setting:
//                    state.destination = .setting(SettingFeature.State())
//                }
//                return .none
//                
//            case .binding(_):
//                return .none
                
//            case .destination(_):
//                return .none
            default:
                return .none
            }
        }
    }
}

extension MainTabFeature {
    @Reducer
    struct Destination {
        @ObservableState
        enum State {
            case contact(ContactFeature.State = .init())
            case message(MessageFeature.State = .init())
            case home(HomeFeature.State = .init())
            case plus(PlusFeature.State = .init())
            case setting(SettingFeature.State = .init())
        }
        
        enum Action {
            case contact(ContactFeature.Action)
            case message(MessageFeature.Action)
            case home(HomeFeature.Action)
            case plus(PlusFeature.Action)
            case setting(SettingFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.contact, action: \.contact) {
                ContactFeature()
            }
            Scope(state: \.message, action: \.message) {
                MessageFeature()
            }
            Scope(state: \.home, action: \.home) {
                HomeFeature()
            }
            Scope(state: \.plus, action: \.plus) {
                PlusFeature()
            }
            Scope(state: \.setting, action: \.setting) {
                SettingFeature()
            }
        }
    }
}

extension MainTabFeature {
    
}
