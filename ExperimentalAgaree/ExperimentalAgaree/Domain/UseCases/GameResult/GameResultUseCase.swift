//
//  GameResultUseCase.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 12/18/24.
//

import Foundation

protocol GameResultUseCase {
    func checkResult() -> String
}


final class DefaultGameResultUseCase: GameResultUseCase {
    
    private let isWin: Bool
    
    init(isWin: Bool) {
        self.isWin = isWin
    }
    
    func checkResult() -> String {
        return isWin ? "통과" : "땡~"
    }
}
