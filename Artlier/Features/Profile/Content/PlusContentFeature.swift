//
//  ContentFeature.swift
//  Artlier
//
//  Created by 김병엽 on 2024/04/03.
//

import ComposableArchitecture
import _PhotosUI_SwiftUI

@Reducer
struct PlusContentFeature {
    @ObservableState
    struct State {
        var isLoading: Bool = false
        var selectedPhotoItems: [PhotosPickerItem] = []
        var selectedPhotoDatas: [Data] = []
        
        var title: String = ""
        var content: String = ""
        var date: String = Date().dateformatter()
        var disclosure: Bool = false
        
        var selectedPhotoValidation: Bool = false
        var titleValidation: Bool = false
        var contentValidation: Bool = false
        var isEnabledButton: Bool = false
    }
    
    enum Action: ViewAction, TCAFeatureAction, BindableAction {
        case view(View)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        case binding(BindingAction<State>)
        
        enum View {
            case closeButtonTapped
            case itemDeleteButtonTapped(Int)
        }
        
        enum InternalAction {
            case loadTransferableResponse(TaskResult<[Data]>)
        }
        
        enum DelegateAction {
            
        }
    }
    
    @Dependency(\.dismiss) var dismiss
//    @Dependency(\.date.now) var date
    @Dependency(PhotoClient.self) var photoClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.selectedPhotoItems):
                return .run { [selectedPhotos = state.selectedPhotoItems] send in
                    await send(
                        .internal(
                            .loadTransferableResponse(
                                await TaskResult {
                                    try await photoClient.multiple_LoadTransferable(selectedPhotos)
                                }
                            )
                        )
                    )
                }
                
            case .binding(\.selectedPhotoItems):
                if state.selectedPhotoItems.isEmpty {
                    state.selectedPhotoValidation = false
                } else {
                    state.selectedPhotoValidation = true
                }
                return self.isEnabledButton(state: &state)
                
            case .binding(\.title):
                if state.title.isEmpty {
                    state.titleValidation = false
                } else {
                    state.titleValidation = true
                }
                return self.isEnabledButton(state: &state)
                
            case .binding(\.content):
                if (state.content.isEmpty || state.content.count < 10) {
                    state.contentValidation = false
                } else {
                    state.contentValidation = true
                }
                return self.isEnabledButton(state: &state)
                
            case let .view(viewAction):
                switch viewAction {
                case .closeButtonTapped:
                    return .run { _ in await self.dismiss() }
                    
                case let .itemDeleteButtonTapped(index):
                    state.selectedPhotoItems.remove(at: index)
                    state.selectedPhotoDatas.remove(at: index)
                    return .none
                }
                
            case let .internal(internalAction):
                switch internalAction {
                case let .loadTransferableResponse(.success(datas)):
                    state.selectedPhotoDatas = datas
                    return .none
                case let .loadTransferableResponse(.failure(error)):
                    // TODO: error
                    return .none
                }
            default:
                return .none
            }
        }
    }
    
    func isEnabledButton(state: inout State) -> Effect<Action> {
        state.isEnabledButton = (state.selectedPhotoValidation && state.titleValidation && state.contentValidation)
        return .none
    }
}
