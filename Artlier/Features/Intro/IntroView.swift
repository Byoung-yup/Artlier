//
//  IntroView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import SwiftUI
import ComposableArchitecture


struct IntroView: View {
    @Bindable var store: StoreOf<IntroFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    Text("나만의 작은 전시관을 만들어보세요.")
                        .font(.system(size: 14))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                BottomView(store: store)
                    .frame(height: 250)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.black, lineWidth: 3)
                            .fill(.white)
                    }
                
            }
            .background(.white)
            .ignoresSafeArea(.all)
        } destination: { store in
            switch store.state {
            case .login:
                if let store = store.scope(state: \.login, action: \.login) {
                    LoginView(store: store)
                }
            case .register:
                if let store = store.scope(state: \.register, action: \.register) {
                    RegisterView(store: store)
                }
            }
        }
    }
}

fileprivate struct BottomView: View {
    let store: StoreOf<IntroFeature>
    
    var body: some View {
        VStack(spacing: 40) {
            
            // MARK: login Buttons
            HStack {
                Button {
                    
                } label: {
                    Circle()
                        .fill(AppColor.SwiftUI.kakaoBK)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Image("kakao")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(10)
                        }
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Circle()
                        .stroke(.black, lineWidth: 2)
                        .fill(.white)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Image("google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                        }
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Circle()
                        .fill(.black)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Image("apple")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                        }
                }
            }
            .frame(maxHeight: 60)
            .padding(.horizontal, 70)
            
            BottomMiddleView(store: store)
                .padding(.horizontal, 70)
            
            Text("개인정보처리방침")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
        }
    }
}

@ViewAction(for: IntroFeature.self)
fileprivate struct BottomMiddleView: View {
    let store: StoreOf<IntroFeature>
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                send(.loginButtonTapped)
            } label: {
                Text("이메일 로그인")
                    .foregroundStyle(.black)
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            
            RoundedRectangle(cornerRadius: 5)
                .fill(.black)
                .frame(width: 2)
            
            Button {
                send(.registerButtonTapped)
            } label: {
                Text("회원가입")
                    .foregroundStyle(.black)
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            
            
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    IntroView(
        store: Store(
            initialState: IntroFeature.State()
        ) {
            IntroFeature()
        }
    )
}
