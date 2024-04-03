//
//  AccountFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/20.
//

import ComposableArchitecture
import SwiftUI
import _PhotosUI_SwiftUI

@Reducer
struct AccountFeature {
    @ObservableState
    struct State {
        var userId: String
        var nickname: String = ""
        var selectedPhoto: PhotosPickerItem?
        var selectedImageData: Data?
        
        var isLoading = false
        var nicknameValidation: Bool = true
        var isEnabledButton: Bool = false
        
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: ViewAction, TCAFeatureAction, BindableAction {
        case view(View)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        case binding(BindingAction<State>)
        case alert(PresentationAction<Alert>)
        
        enum View {
            case createUserButtonTapped
        }
        
        enum InternalAction {
            case loadTransferableResponse(TaskResult<Data>)
            case createUserResponse(TaskResult<Bool>)
        }
        
        enum DelegateAction {
            case createUser
            case createUserError
        }
        
        enum Alert {
            case createUserError
        }
    }
    
    @Dependency(PhotoClient.self) var photoClient
    @Dependency(UserClient.self) var userClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.selectedPhoto):
                return .run { [selectedPhoto = state.selectedPhoto] send in
                    await send(
                        .internal(
                            .loadTransferableResponse(
                                await TaskResult {
                                    if let selectedPhoto = selectedPhoto {
                                        try await photoClient.single_LoadTransferable(selectedPhoto)
                                    } else {
                                        Data()
                                    }
                                }
                            )
                        )
                    )
                }
                
            case .binding(\.nickname):
                if state.nickname.isEmpty {
                    return .none
                } else {
                    state.nicknameValidation = state.nickname.isValidNickname()
                    return self.isEnabledButton(state: &state)
                }
                
            case let .view(viewAction):
                switch viewAction {
                case .createUserButtonTapped:
                    state.isLoading = true
                    return .run { [id = state.userId, nickname = state.nickname, imageData = state.selectedImageData] send in
                        await send(
                            .internal(
                                .createUserResponse(
                                    await TaskResult {
                                        try await userClient.createUser(id, nickname, imageData ?? Data())
                                    }
                                )
                            )
                        )
                    }
                }
                
            case let .internal(internalAction):
                switch internalAction {
                case let .loadTransferableResponse(.success(data)):
                    state.selectedImageData = data
                    return .none
                case .loadTransferableResponse(.failure(_)):
                    // TODO: - alert
                    return .none
                    
                case .createUserResponse(.success(_)):
                    state.isLoading = false
                    return .send(.delegate(.createUser))
                case let .createUserResponse(.failure(error)):
                    switch error as? AppError {
                    case .FirebaseExistDataError:
                        state.alert = .existDataErrorAlert
                        state.isLoading = false
                        return .none
                        
                    default:
                        state.alert = AlertState (
                            title: TextState("안내"),
                            message: TextState("알 수 없는 오류입니다."),
                            buttons: [
                                ButtonState(
                                    role: .cancel,
                                    action: .createUserError,
                                    label: {
                                        TextState("확인")
                                    }
                                )
                            ]
                        )
                        return .none
                    }
                }
                
            case .alert(.presented(.createUserError)):
                return .send(.delegate(.createUserError))
                
            default:
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
    }
    
    func isEnabledButton(state: inout State) -> Effect<Action> {
        if (state.nickname.count < 2 || state.nickname.count > 6) {
            state.isEnabledButton = false
            return .none
        } else {
            state.isEnabledButton = state.nicknameValidation
            return .none
        }
    }
}

extension AccountFeature {
//    enum ImageState {
//            case empty
//            case loading(Progress)
//            case success(Image)
//            case failure(Error)
//    }
//    
    
    private func loadTransferable(from imageSelection: PhotosPickerItem?) async throws -> Data {
        do {
            guard let imageSelection = imageSelection else { return Data() }
            return try await imageSelection.loadTransferable(type: Data.self)!
        } catch {
            throw AppError.FirebaseError
        }
    }
}
