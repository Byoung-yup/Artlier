//
//  PhotoClient.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/28.
//

import ComposableArchitecture
import _PhotosUI_SwiftUI

struct PhotoClient {
    var loadTransferable: @Sendable (_ selectedPhoto: PhotosPickerItem) async throws -> Data
    
    init(
        loadTransferable: @escaping @Sendable (_ selectedPhoto: PhotosPickerItem) async throws -> Data
    ) {
        self.loadTransferable = loadTransferable
    }
}

extension PhotoClient: DependencyKey {
    static let liveValue: Self = Self(
        loadTransferable: { selectedPhoto in
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
        }
    )
}

extension DependencyValues {
    var photoClient: PhotoClient {
        get { self[PhotoClient.self] }
        set { self[PhotoClient.self] = newValue }
    }
}
