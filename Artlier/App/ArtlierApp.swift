//
//  ArtlierApp.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import SwiftUI
import ComposableArchitecture

@main
struct ArtlierApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView(
                store: Store(
                    initialState: AppFeature.State()
                ) {
                    AppFeature()
                }
            )
        }
    }
}
