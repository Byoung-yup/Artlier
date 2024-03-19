//
//  RegisterView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/08.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: RegisterFeature.self)
struct RegisterView: View {
    @Bindable var store: StoreOf<RegisterFeature>
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
                .ignoresSafeArea(.all)
            
            ContentView(store: store)
                .padding(.top, 21)

        }
        .overlay(alignment: .bottom) {
            // MARK: register Button
            Button {
                send(.registerButtonTapped)
            } label: {
                if store.isLoading {
                    ProgressView()
                } else {
                    Text("가입하기")
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
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

fileprivate struct ContentView: View {
    @Bindable var store: StoreOf<RegisterFeature>
    
    var body: some View {
        VStack(spacing: 30) {
            emailView
                
            passwordView
            
            repasswordView
        }
        .padding(.horizontal, 21)
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
                    prompt: Text("영문,숫자,특수문자 포함 8-12자리")
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
    
    // MARK: repassword
    var repasswordView: some View {
        VStack(spacing: 15) {
            Text("비밀번호 확인")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                SecureField(
                    "",
                    text: $store.repassword,
                    prompt: Text("비밀번호를 재입력하세요.")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                )
                .textContentType(nil)
                .modifier(UnderlineTextField())
                
                (Text(Image(systemName: "exclamationmark.circle")) + Text("비밀번호가 일치하지 않습니다."))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(HideViewModifier(isHidden: store.repasswordValidation))
            }
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(
            store: Store(
                initialState: RegisterFeature.State()
            ) {
                RegisterFeature()
            }
        )
    }
}
