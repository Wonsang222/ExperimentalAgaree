//
//  AuthCheckable.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/10/24.
//

import Foundation

protocol AuthCheckable {
    func requestAuthorization()
    func checkAuthorizatio(completion: @escaping (Bool) -> Void)
    func getDescription() -> String
}
