//
//  LoginView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/08.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: LoginFeature.self)
struct LoginView: View {
    @Bindable var store: StoreOf<LoginFeature>
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
                .ignoresSafeArea(.all)
            
            VStack(spacing: 30) {
                emailView
                
                passwordView
            }
            .padding(.top, 21)
            .padding(.horizontal, 21)
        }
        .overlay(alignment: .bottom) {
            // MARK: register Button
            Button {
                send(.loginButtonTapped)
            } label: {
                if store.isLoading {
                    ProgressView()
                } else {
                    Text("로그인하기")
                }
            }
            .buttonStyle(DefaultButtonStyle(textColor: .white))
            .opacity(store.isEnabledButton ? 1.0 : 0.3)
            .disabled(!(store.isEnabledButton))
            .padding(.horizontal, 21)
            .padding(.bottom, 15)
            .ignoresSafeArea(.keyboard)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    send(.exitButtonTapped)
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("로그인")
        .navigationBarTitleDisplayMode(.inline)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    // MARK: email
    var emailView: some View {
        VStack(spacing: 15) {
            Text("이메일")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                TextField(
                    "",
                    text: $store.email,
                    prompt: Text("이메일을 입력하세요.")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                )
                .textContentType(.username)
                .keyboardType(.emailAddress)
                .modifier(UnderlineTextField())
                
                (Text(Image(systemName: "exclamationmark.circle")) + Text("이메일 형식이 올바르지 않습니다."))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(HideViewModifier(isHidden: store.emailValidation))
            }
        }
    }
    
    // MARK: password
    var passwordView: some View {
        VStack(spacing: 15) {
            Text("비밀번호")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                SecureField(
                    "",
                    text: $store.password,
                    prompt: Text("비밀번호를 입력하세요.")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                )
                .textContentType(nil)
                .modifier(UnderlineTextField())
                
                (Text(Image(systemName: "exclamationmark.circle")) + Text("비밀번호 형식이 올바르지 않습니다."))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(HideViewModifier(isHidden: store.passwordValidation))
            }
        }
    }
}

#Preview {
    LoginView(
        store: Store(
            initialState: LoginFeature.State()
        ) {
            LoginFeature()
        }
    )
}
