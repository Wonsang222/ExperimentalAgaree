//
//  GameSelectionUseCase.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/7/24.
//

import Foundation

protocol GameSelectionUseCase {
    func requestGameAuthorization()
    func checkGameAuthrization(completion: @escaping (String?) -> Void)
    func getTargetModel() -> GameInfo
}

final class DefaultGameSelectionUseCase: GameSelectionUseCase {
    
    private let targetGame: GameInfo
    private let gameAuths: [AuthRepository]
    
    init(
        targetGame: GameInfo,
        gameAuths: [AuthRepository]
    ) {
        self.targetGame = targetGame
        self.gameAuths = gameAuths
    }
    
    func requestGameAuthorization() {
        for auth in gameAuths {
            auth.reqAuth()
        }
    }
    
    func checkGameAuthrization(completion: @escaping (String?) -> Void) {
        var noAuthServiceDescription = [String]()
        for auth in gameAuths {
            auth.checkAuth { isAuthorized in
                if !isAuthorized {
                    noAuthServiceDescription.append(auth.description)
                }
            }
        }
        
        if !noAuthServiceDescription.isEmpty {
            let description = noAuthServiceDescription.joined(separator: ",")
            completion(description)
            return
        }
        completion(nil)
    }
    
    func getTargetModel() -> GameInfo {
        return targetGame
    }
}
