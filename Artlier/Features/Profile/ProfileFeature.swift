//
//  PlusFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import ComposableArchitecture

@Reducer
struct ProfileFeature {
    @ObservableState
    struct State {
        var isLoading: Phase = .notRequested
        var currentUser: AppUser = AppUser.mockData
        
        @Presents var destination: Destination.State?
    }
    
    enum Action: ViewAction, TCAFeatureAction {
        case view(View)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        case destination(PresentationAction<Destination.Action>)
        
        enum View {
            case onAppear
            case plusButtonTapped
        }
        
        enum InternalAction {
            
        }
        
        enum DelegateAction {
            
        }
    }
    
    @Dependency(UserClient.self) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAppear:
                    print("onAppear")
                    state.currentUser = self.userClient.currentUser()
                    return .none
                case .plusButtonTapped:
                    state.destination = .content(PlusContentFeature.State())
                    return .none
                }
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension ProfileFeature {
    @Reducer
    enum Destination {
        case content(PlusContentFeature)
    }
//        
//        enum Action {
//            case content(PlusContentFeature.Action)
//        }
//        
//        var body: some ReducerOf<Self> {
//            Scope(state: \.content, action: \.content) {
//                PlusContentFeature()
//            }
//        }
}
