//
//  LoadingView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            
            ProgressView()
                .controlSize(.regular)
                .tint(.gray)
        }
    }
}

#Preview {
    LoadingView()
}
