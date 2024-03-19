//
//  MessageFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import ComposableArchitecture

@Reducer
struct MessageFeature {
    @ObservableState
    struct State {
        
    }
    
    enum Action: ViewAction, TCAFeatureAction {
        case view(View)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        enum View {
            
        }
        
        enum InternalAction {
            
        }
        
        enum DelegateAction {
            
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
