//
//  IntroFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import Foundation
import ComposableArchitecture

@Reducer
struct IntroFeature {
    @ObservableState
    struct State {
        var phase: Phase = .notRequested
        
        var path = StackState<Path.State>()
    }
    
    enum Action: ViewAction, TCAFeatureAction {
        case view(View)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        case path(StackAction<Path.State, Path.Action>)
        
        enum View {
            case loginButtonTapped
            case registerButtonTapped
        }
        
        enum InternalAction {
            
        }
        
        enum DelegateAction {
            
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .loginButtonTapped:
                    state.path.append(.login(LoginFeature.State()))
                    return .none
                case .registerButtonTapped:
                    print("registerButtonTapped")
                    state.path.append(.register(RegisterFeature.State()))
                    return .none
                }
                
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

extension IntroFeature {
    @Reducer
    struct Path {
        @ObservableState
        enum State {
            case login(LoginFeature.State)
            case register(RegisterFeature.State)
        }
        
        enum Action {
            case login(LoginFeature.Action)
            case register(RegisterFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.login, action: \.login) {
                LoginFeature()
            }
            
            Scope(state: \.register, action: \.register) {
                RegisterFeature()
            }
        }
    }
}
