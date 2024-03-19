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
        var email = ""
        var password = ""
        
        var isLoading = false
        var emailValidation: Bool = true
        var passwordValidation: Bool = true
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
            case loginButtonTapped
        }
        
        enum InternalAction {
            case loginResponse(TaskResult<String>)
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
                case .loginButtonTapped:
                    state.isLoading = true
                    return .run { [email = state.email, password = state.password] send in
                        await send(
                            .internal(
                                .loginResponse(
                                    await TaskResult {
                                        try await authenticationClient.signIn(email, password)
                                    }
                                )
                            )
                        )
                    }
                }
                
            case let .internal(internalAction):
                switch internalAction {
                case let .loginResponse(.success(userId)):
                    state.isLoading = false
                    return .run { _ in await self.dismiss() }
                case let .loginResponse(.failure(error)):
                    state.isLoading = false
                    
                    switch error as! AppError {
                    case .FirebaseinvalidPasswordError:
                        state.alert = .PasswordErrorAlert
                    default:
                        state.alert = .unknownErrorAlert
                    }
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
                
                
            case .alert(_):
                return .none
                
            case .binding(_):
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
    }
    
    func isEnabledButton(state: inout State) -> Effect<Action> {
        if (state.email.isEmpty || state.password.isEmpty) {
            state.isEnabledButton = false
            return .none
        } else {
            state.isEnabledButton = (state.emailValidation && state.passwordValidation)
            return .none
        }
    }
}
