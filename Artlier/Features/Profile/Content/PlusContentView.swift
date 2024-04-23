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
    let store: StoreOf<PlusContentFeature>
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    PhotoView(store: store)
                        .frame(height: 160)
                    
                    TitleView(store: store)
                        .frame(height: 60)
                    
                    ContentTitleView(store: store)
                        .frame(height: 250)
                    
                    CalendarView(store: store)
                        .frame(height: 40)
                    
                    DisclosureView(store: store)
                        .frame(height: 40)
                    
                    Button {
                        send(.createAlbumButtonTapped)
                    } label: {
                        if store.isLoading {
                            ProgressView()
                        } else {
                            Text("게시하기")
                        }
                    }
                    .buttonStyle(DefaultButtonStyle(textColor: .white))
                    .opacity(store.isEnabledButton ? 1.0 : 0.3)
                    .disabled(!(store.isEnabledButton))
                    .padding(.horizontal, 21)
                    
                }
                
            }
            .padding(.top, 40)
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

@ViewAction(for: PlusContentFeature.self)
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows, spacing: 20) {
                        ForEach(store.selectedPhotoDatas, id: \.self) { data in
                            if let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 120 * 9 / 16)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            if let index = store.selectedPhotoDatas.firstIndex(of: data) {
                                                send(.itemDeleteButtonTapped(index))
                                            }
                                        } label: {
                                            Image(systemName: "xmark.circle")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .foregroundStyle(.black)
                                                .background(.white)
                                                .clipShape(Circle())
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
            
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
                .lineSpacing(10)
                .foregroundColor(.gray)
                .padding()
                .background(.white)
                .border(.black, width: 2)
            }
        }
        .padding(.horizontal, 21)
    }
}

fileprivate struct CalendarView: View {
    let store: StoreOf<PlusContentFeature>
    
    var body: some View {
        HStack {
            Text("전시 날짜")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text(store.date)
                    .font(.system(size: 14, weight: .semibold))
            }
            
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 21)
    }
}

fileprivate struct DisclosureView: View {
    @Bindable var store: StoreOf<PlusContentFeature>
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Toggle("이웃 공개", isOn: $store.disclosure)
                    .font(.system(size: 17, weight: .semibold))
                    .toggleStyle(SwitchToggleStyle(tint: .black))
            }
            
            Text("콘텐츠가 이웃에게만 보여집니다.")
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
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
