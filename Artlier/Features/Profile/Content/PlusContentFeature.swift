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
        var selectedPhotoItems: [PhotosPickerItem] = []
        var selectedPhotoDatas: [Data] = []
        
        var title: String = ""
        var content: String = ""
    }
    
    enum Action: ViewAction, TCAFeatureAction, BindableAction {
        case view(View)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        case binding(BindingAction<State>)
        
        enum View {
            case closeButtonTapped
        }
        
        enum InternalAction {
            case loadTransferableResponse(TaskResult<[Data]>)
        }
        
        enum DelegateAction {
            
        }
    }
    
    @Dependency(\.dismiss) var dismiss
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
                
            case let .view(viewAction):
                switch viewAction {
                case .closeButtonTapped:
                    return .run { _ in await self.dismiss() }
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
}
