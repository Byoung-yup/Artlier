//
//  TCAFeatureAction.swift
//  Artlier
//
//  Created by 김병엽 on 2024/03/07.
//

import Foundation

protocol TCAFeatureAction {
    associatedtype ViewAction
    associatedtype InternalAction
    associatedtype DelegateAction
    
    static func view(_: ViewAction) -> Self
    static func `internal`(_: InternalAction) -> Self
    static func delegate(_: DelegateAction) -> Self
}
