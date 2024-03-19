//
//  RegisterFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/08.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RegisterFeature {
    @ObservableState
    struct State {
        var email: String = ""
        var password: String = ""
        var repassword: String = ""
        
        var isLoading = false
        var emailValidation: Bool = true
        var passwordValidation: Bool = true
        var repasswordValidation: Bool = true
        var isEnabledButton: Bool = false
        
        @Presents var alert: AlertState<Void>?
    }
    
    enum Action: ViewAction, TCAFeatureAction, BindableAction {
        case view(View)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        case binding(BindingAction<State>)
        case alert(PresentationAction<Void>)
        
        enum View {
            case exitButtonTapped
            case registerButtonTapped
        }
        
        enum InternalAction {
            case registerResponse(TaskResult<Void>)
        }
        
        enum DelegateAction {
            
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.authenticationClient) var authenticationClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .exitButtonTapped:
                    return .run { _ in await self.dismiss() }
                case .registerButtonTapped:
                    state.isLoading = true
                    return .run { [email = state.email, password = state.password] send in
                        await send(
                            .internal(
                                .registerResponse(
                                    await TaskResult {
                                        try await authenticationClient.createUser(email, password)
                                    }
                                )
                            )
                        )
                    }
                }
                
            case let .internal(internalAction):
                switch internalAction {
                case .registerResponse(.success(())):
                    state.isLoading = false
                    return .run { _ in await self.dismiss() }
                case let .registerResponse(.failure(error)):
                    state.isLoading = false
                    state.alert = .unknownErrorAlert
                    return .none
                }
                
            case .binding(\.email):
                if state.email.isEmpty {
                    return .none
                } else {
                    state.emailValidation = state.email.isValidEmail()
                    return self.isEnabledButton(state: &state)
                }
            case .binding(\.password):
                if state.password.isEmpty {
                    return .none
                } else {
                    state.passwordValidation = state.password.isValidPassword()
                    return self.isEnabledButton(state: &state)
                }
            case .binding(\.repassword):
                if state.repassword.isEmpty {
                    return .none
                } else {
                    state.repasswordValidation = (state.password == state.repassword)
                    return self.isEnabledButton(state: &state)
                }
                
            case .binding(_):
                return .none
                
            case .alert(_):
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
    }
    
    func isEnabledButton(state: inout State) -> Effect<Action> {
        if (state.email.isEmpty || state.password.isEmpty || state.repassword.isEmpty) {
            state.isEnabledButton = false
            return .none
        } else {
            state.isEnabledButton = (state.emailValidation && state.passwordValidation && state.repasswordValidation)
            return .none
        }
    }
}
