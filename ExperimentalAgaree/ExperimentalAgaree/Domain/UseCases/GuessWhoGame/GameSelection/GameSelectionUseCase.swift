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
    private let gameAuths: [AuthCheckable]
    
    init(
        targetGame: GameInfo,
        gameAuths: [AuthCheckable]
    ) {
        self.targetGame = targetGame
        self.gameAuths = gameAuths
    }
    
    func requestGameAuthorization() {
        for auth in gameAuths {
            auth.requestAuthorization()
        }
    }
    
    func checkGameAuthrization(completion: @escaping (String?) -> Void) {
        var noAuthService = [String]()
        for auth in gameAuths {
            auth.checkAuthorizatio { isAuthorized in
                if !isAuthorized {
                    noAuthService.append(auth.getDescription())
                }
            }
        }
        
        if !noAuthService.isEmpty {
            let noServices = noAuthService.joined(separator: ",")
            completion(noServices)
            return
        }
        completion(nil)
    }
    
    func getTargetModel() -> GameInfo {
        return targetGame
    }
}
