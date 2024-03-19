//
//  AppFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    struct State {
        var userId: String
        var phase: Phase = .success
        
        var intro = IntroFeature.State()
        var mainTab = MainTabFeature.State()
    }
    
    enum Action: TCAFeatureAction {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        case intro(IntroFeature.Action)
        case mainTab(MainTabFeature.Action)
        
        enum ViewAction {
            case task
        }
        
        enum InternalAction {
            case listenAuthStateResponse(TaskResult<String>)
        }
        
        enum DelegateAction {
            
        }
    }
    
    @Dependency(\.authenticationClient) var authenticationClient
    
    var body: some ReducerOf<Self> {
        Scope(state: \.intro, action: \.intro) {
            IntroFeature()
        }
        Scope(state: \.mainTab, action: \.mainTab) {
            MainTabFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .task:
                    state.phase = .loading
                    return .run { send in
                        for try await result in try await self.authenticationClient.listenAuthState() {
                            await send(.internal(.listenAuthStateResponse(.success(result!))))
                        }
                    } catch: { error, send in
                        await send(.internal(.listenAuthStateResponse(.failure(error))))
                    }
                }
                
            case let .internal(internalAction):
                switch internalAction {
                case let .listenAuthStateResponse(.success(userId)):
                    state.userId = userId
                    state.phase = .success
                    print("Success - listenAuthStateResponse")
                    return .none
                    
                case let .listenAuthStateResponse(.failure(error)):
                    state.phase = .fail
                    print("Failure - listenAuthStateResponse")
                    return .none
                }
                
                
            case .intro:
                return .none
                
            case .mainTab:
                return .none
            }
        }
    }
}
