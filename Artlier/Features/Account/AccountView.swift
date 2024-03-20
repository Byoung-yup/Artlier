//
//  AccountView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/20.
//

import SwiftUI
import ComposableArchitecture

struct AccountView: View {
    let store: StoreOf<AccountFeature>
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.white
                    .ignoresSafeArea(.all)
                
                ContentView(store: store)
                    .padding(.top, 21)
            }
        }
        .overlay(alignment: .bottom) {
            // MARK: register Button
            Button {
                
            } label: {
                if store.isLoading {
                    ProgressView()
                } else {
                    Text("등록하기")
                }
            }
            .buttonStyle(DefaultButtonStyle(textColor: .white))
            .opacity(store.isEnabledButton ? 1.0 : 0.3)
            .disabled(!(store.isEnabledButton))
            .padding(.horizontal, 21)
            .padding(.bottom, 15)
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("계정등록")
        .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate struct ContentView: View {
    let store: StoreOf<AccountFeature>
    
    fileprivate var body: some View {
        VStack {
            Button {
                
            } label: {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 80, height: 80)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AccountView(
            store: Store(
                initialState: AccountFeature.State()
            ) {
                AccountFeature()
            }
        )
    }
}
