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
        var userId: String
        
        var account: AccountFeature.State?
        
        var contact: ContactFeature.State = .init()
        var message: MessageFeature.State = .init()
        var home: HomeFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        var setting: SettingFeature.State = .init()
        
        var phase: Phase = .notRequested
    }
    
    enum Action: ViewAction, TCAFeatureAction {
        case view(View)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        case account(AccountFeature.Action)
        
        case contact(ContactFeature.Action)
        case message(MessageFeature.Action)
        case home(HomeFeature.Action)
        case profile(ProfileFeature.Action)
        case setting(SettingFeature.Action)
        
        enum View {
            case onAppear
        }
        
        enum InternalAction {
            case existUserResponse(TaskResult<Bool>)
        }
        
        enum DelegateAction {
            
        }
    }
    
    @Dependency(\.userClient) var userClient
    
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
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        Scope(state: \.setting, action: \.setting) {
            SettingFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAppear:
                    state.phase = .loading
                    return .run { [userId = state.userId] send in
                        await send(
                            .internal(
                                .existUserResponse(
                                    await TaskResult {
                                        try await userClient.existUser(userId)
                                    }
                                )
                            )
                        )
                    }
                }
                
            case let .internal(internalAction):
                switch internalAction {
                case let .existUserResponse(.success(status)):
                    if status {
                        state.phase = .success
                    } else {
                        state.phase = .fail
                        state.account = AccountFeature.State()
                    }
                    return .none
                case .existUserResponse(.failure(_)):
                    state.phase = .fail
                    return .none
                }
                
            default:
                return .none
            }
        }
        .ifLet(\.account, action: \.account) {
            AccountFeature()
        }
    }
}
