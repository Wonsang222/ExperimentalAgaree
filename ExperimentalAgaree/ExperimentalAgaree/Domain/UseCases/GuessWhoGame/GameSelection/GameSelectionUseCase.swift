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
    func getTargetModel() -> GameInfo
    func setGamePlayer(num: UInt8)
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
    
    func requestGameAuthorization() {
        for auth in gameAuths {
            auth.requestAuthorization()
        }
    }
    
    func checkGameAuthrization() -> Bool {
        var script = ""
        for auth in gameAuths {
            auth.checkAuthorizatio { isAuthorized in
                if !isAuthorized {
                    
                }
            }
        }
        return true
    }
    
    func getTargetModel() -> GameInfo {
        return targetGame
    }
    
    func setGamePlayer(num: UInt8) {
        targetGame.setPlayer(num)
    }
}
