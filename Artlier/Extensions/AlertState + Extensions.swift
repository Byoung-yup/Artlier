//
//  AlertState + Extensions.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/09.
//

import ComposableArchitecture

extension AlertState {
//    static var confirmPasswordErrorAlert: Self {
//        AlertState (
//            title: TextState("안내"),
//            message: TextState("비밀번호가 일치하지 않습니다."),
//            buttons: [
//                ButtonState(role: .cancel, label: {
//                    TextState("확인")
//                })
//            ]
//        )
//    }
    static var unknownErrorAlert: Self {
        AlertState (
            title: TextState("안내"),
            message: TextState("알 수 없는 오류입니다."),
            buttons: [
                ButtonState(role: .cancel, label: {
                    TextState("확인")
                })
            ]
        )
    }
}
