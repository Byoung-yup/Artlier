//
//  LoginFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/08.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LoginFeature {
    @ObservableState
    struct State {
        
    }
    
    enum Action: TCAFeatureAction {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        enum ViewAction {
            
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
