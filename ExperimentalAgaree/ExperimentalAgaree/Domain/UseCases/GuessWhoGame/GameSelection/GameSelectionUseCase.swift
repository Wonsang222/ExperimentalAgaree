//
//  GameSelectionUseCase.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/7/24.
//

import Foundation

protocol GameSelectionUseCase {
    func requestGameAuthorization()
    func checkGameAuthrization() -> Bool
    func getGameTitle() -> String
}

final class DefaultGameSelectionUseCase: GameSelectionUseCase {
    
    private let targetGame: GameInfo
    private let gameAuths: [AuthCheckable]
    private let instView: BaseView
    
    init(
        targetGame: GameInfo,
        gameAuths: [AuthCheckable],
        instView: BaseView
    ) {
        self.targetGame = targetGame
        self.gameAuths = gameAuths
        self.instView = instView
    }
    
    func requestGameAuthorization()  {
        for auth in gameAuths {
            auth.requestAuthorization()
        }
    }
    
    func checkGameAuthrization() -> Bool {
        for auth in gameAuths {
            if !auth.checkAuthorization() {
                return false
            }
        }
        return true
    }
    
    func getGameTitle() -> String {
        return targetGame.gamePath.description
    }
}
