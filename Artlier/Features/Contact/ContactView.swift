//
//  ContactView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/18.
//

import SwiftUI
import ComposableArchitecture

struct ContactView: View {
    let store: StoreOf<ContactFeature>
    
    var body: some View {
        ZStack {
            
           Text("contactView")
        }
        
    }
}

#Preview {
    ContactView(
        store: Store(
            initialState: ContactFeature.State()
        ) {
            ContactFeature()
        }
    )
}
