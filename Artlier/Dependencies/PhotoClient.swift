//
//  PhotoClient.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/28.
//

import ComposableArchitecture
import _PhotosUI_SwiftUI

struct PhotoClient {
    var single_LoadTransferable: @Sendable (_ selectedPhoto: PhotosPickerItem) async throws -> Data
    var multiple_LoadTransferable: @Sendable (_ selectedPhotos: [PhotosPickerItem]) async throws -> [Data]
    
    init(
        single_LoadTransferable: @escaping @Sendable (_ selectedPhoto: PhotosPickerItem) async throws -> Data,
        multiple_LoadTransferable: @escaping @Sendable (_ selectedPhotos: [PhotosPickerItem]) async throws -> [Data]
    ) {
        self.single_LoadTransferable = single_LoadTransferable
        self.multiple_LoadTransferable = multiple_LoadTransferable
    }
}

extension PhotoClient: DependencyKey {
    static let liveValue: Self = Self(
        single_LoadTransferable: { selectedPhoto in
            do {
                guard let data = try await selectedPhoto.loadTransferable(type: Data.self) else {
                    return Data()
                }
                
                guard let uiImage = UIImage(data: data),
                      let jpegData = uiImage.jpegData(compressionQuality: 0.8) else {
                    return Data()
                }
                
                return jpegData
            } catch let error {
                throw error
            }
        },
        multiple_LoadTransferable: { selectedPhotos in
            do {
                var datas: [Data] = []
                
                for item in selectedPhotos {
                    guard let data = try await item.loadTransferable(type: Data.self) else {
                        return [Data()]
                    }
                    
                    guard let uiImage = UIImage(data: data),
                          let jpegData = uiImage.jpegData(compressionQuality: 0.8) else {
                        return [Data()]
                    }
                    
                    datas.append(jpegData)
                }
                
                return datas
            } catch let error {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var photoClient: PhotoClient {
        get { self[PhotoClient.self] }
        set { self[PhotoClient.self] = newValue }
    }
}
