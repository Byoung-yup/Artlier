//
//  CustomNavigationBar.swift
//  Artlier
//
//  Created by 김병엽 on 2024/04/03.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayLeftBtn: Bool
    let isDisplayRightBtn: Bool
    let leftBtnAction: () -> Void
    let rightBtnAction: () -> Void
    let title: String
    
    init(
        isDisplayLeftBtn: Bool = true,
        isDisplayRightBtn: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        rightBtnAction: @escaping () -> Void = {},
        title: String = "Title"
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.title = title
    }
    var body: some View {
        HStack {
            if isDisplayLeftBtn {
                Button {
                    leftBtnAction()
                } label: {
                    Image(systemName: "xmark")
                }
                .padding(.leading)
            }
            
            Spacer()
            
            if isDisplayRightBtn {
                Button {
                    leftBtnAction()
                } label: {
                    Image(systemName: "xmark")
                }
                .padding(.trailing)
            }
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 14)
        .frame(height: 20)
        .overlay(alignment: .center) {
            Text(title)
                .foregroundStyle(.black)
                .font(.system(size: 14, weight: .semibold))
        }
    }
}

#Preview {
    CustomNavigationBar()
}
