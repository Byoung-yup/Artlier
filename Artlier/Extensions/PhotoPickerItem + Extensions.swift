//
//  PhotoPickerItem + Extensions.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/21.
//

//import SwiftUI
//import _PhotosUI_SwiftUI
//
//extension PhotosPickerItem {
//    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
//        return imageSelection.loadTransferable(type: Data.self) { result in
//            DispatchQueue.main.async {
//                guard imageSelection == imageSelection else { return }
//                switch result {
//                case .success(let image?):
//                    // Handle the success case with the image.
//                case .success(nil):
//                    // Handle the success case with an empty value.
//                case .failure(let error):
//                    // Handle the failure case with the provided error.
//                }
//            }
//        }
//    }
//}
