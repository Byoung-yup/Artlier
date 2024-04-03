//
//  ContentView.swift
//  Artlier
//
//  Created by 김병엽 on 2024/04/03.
//

import SwiftUI
import ComposableArchitecture
import _PhotosUI_SwiftUI

@ViewAction(for: PlusContentFeature.self)
struct PlusContentView: View {
    @Bindable var store: StoreOf<PlusContentFeature>
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                PhotoView(store: store)
                    .frame(height: 150)
                
                TitleView(store: store)
                    .frame(height: 60)
                
                ContentTitleView(store: store)
                    .frame(height: 250)
            }
        }
        .overlay(alignment: .top) {
            CustomNavigationBar(
                isDisplayLeftBtn: true,
                isDisplayRightBtn: false,
                leftBtnAction: {
                    send(.closeButtonTapped)
                },
                title: "전시하기"
            )
        }
    }
}

fileprivate struct PhotoView: View {
    @Bindable var store: StoreOf<PlusContentFeature>
    
    let rows = [GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 20) {
                PhotosPicker(
                    selection: $store.selectedPhotoItems,
                    maxSelectionCount: 5,
                    matching: .images
                ) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .stroke(.black, lineWidth: 2)
                        .frame(width: 120 * 9 / 16)
                        .overlay(alignment: .center) {
                            VStack(spacing: 10) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                Group {
                                    VStack {
                                        Text("사진추가")
                                        Text("\(store.selectedPhotoDatas.count) / 5")
                                    }
                                }
                                .font(.system(size: 11))
                            }
                            .foregroundStyle(.black)
                        }
                    
                }
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 20) {
                        ForEach(store.selectedPhotoDatas, id: \.self) { data in
                            if let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 120 * 9 / 16)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            
            Text("불건전한 콘텐츠는 삭제 처리 될 수 있습니다.")
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 21)
    }
}

fileprivate struct TitleView: View {
    @Bindable var store: StoreOf<PlusContentFeature>
    
    var body: some View {
        VStack {
            Text("타이틀")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            TextField(
                "",
                text: $store.title,
                prompt: Text("전시관 타이틀을 입력하세요.")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            )
            .modifier(UnderlineTextField())
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 21)
    }
}

fileprivate struct ContentTitleView: View {
    @Bindable var store: StoreOf<PlusContentFeature>
    
    @State var placeholder: String = "타인에게 보여줄 전시관의 컨셉을 작성 해주세요."
    
    var body: some View {
        VStack(spacing: 15) {
            Text("전시 내용")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                Group {
                    if store.content.isEmpty {
                        TextEditor(text: $placeholder)
                            .disabled(true)
                    }
                    
                    TextEditor(text: $store.content)
                        .opacity(store.content.isEmpty ? 0.25 : 1)
                }
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding()
                .border(.black, width: 2)
            }
        }
        .padding(.horizontal, 21)
    }
}

#Preview {
    PlusContentView(
        store: Store(
            initialState: PlusContentFeature.State()
        ) {
            PlusContentFeature()
        }
    )
}
