//
//  AccountView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/20.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

@ViewAction(for: AccountFeature.self)
struct AccountView: View {
    @Bindable var store: StoreOf<AccountFeature>
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
                .ignoresSafeArea(.all)
            
            ContentView(store: store)
                .padding(.top, 21)
                .padding(.horizontal, 21)
        }
        
        .overlay(alignment: .bottom) {
            // MARK: submit Button
            Button {
                send(.createUserButtonTapped)
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
        .navigationTitle("계정등록")
        .navigationBarTitleTextColor(.black)
        .navigationBarTitleDisplayMode(.inline)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

fileprivate struct ContentView: View {
    @Bindable var store: StoreOf<AccountFeature>
    
    fileprivate var body: some View {
        VStack(spacing: 25) {
            PhotosPicker(selection: $store.selectedPhoto, matching: .images) {
                if let selectedImageData = store.selectedImageData {
                    if let image = UIImage(data: selectedImageData) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(.black, lineWidth: 2.0)
                            }
                    }
                } else {
                    Image(systemName: "person.fill.viewfinder")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.black)
                }
            }
            
            nicknameView
        }
    }
    
    var nicknameView: some View {
        VStack(spacing: 10) {
            TextField(
                "",
                text: $store.nickname,
                prompt: Text("닉네임을 설정해주세요. (특수문자 제외, 2~6글자)")
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            )
            .textContentType(.username)
            .multilineTextAlignment(.center)
            .modifier(UnderlineTextField())
            
            (Text(Image(systemName: "exclamationmark.circle")) + Text("닉네임 형식이 올바르지 않습니다."))
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .center)
                .modifier(HideViewModifier(isHidden: store.nicknameValidation))
        }
    }
}

#Preview {
    NavigationStack {
        AccountView(
            store: Store(
                initialState: AccountFeature.State(
                    userId: ""
                )
            ) {
                AccountFeature()
            }
        )
    }
}
