//
//  AlertState + Extensions.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/09.
//

import ComposableArchitecture

extension AlertState {
    // MARK: password Alert
    static var PasswordErrorAlert: Self {
        AlertState (
            title: TextState("안내"),
            message: TextState("비밀번호가 올바르지 않습니다."),
            buttons: [
                ButtonState(role: .cancel, label: {
                    TextState("확인")
                })
            ]
        )
    }
    
    // MARK: common Alert
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
    
    // MARK: exist Data Alert
    static var existDataErrorAlert: Self {
        AlertState (
            title: TextState("안내"),
            message: TextState("이미 사용 중인 닉네임입니다."),
            buttons: [
                ButtonState(role: .cancel, label: {
                    TextState("확인")
                })
            ]
        )
    }
}
