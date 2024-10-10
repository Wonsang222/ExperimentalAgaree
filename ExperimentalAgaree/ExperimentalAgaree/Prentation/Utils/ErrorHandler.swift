//
//  ErrorHandler.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/10/24.
//

import Foundation

final class ErrorHandler {
    let errMsg: String
    var completion: (() -> Void)?
    
    init(
        errMsg: String,
        completion: ( () -> Void)? = nil
    ) {
        self.errMsg = errMsg
        self.completion = completion
    }
}
