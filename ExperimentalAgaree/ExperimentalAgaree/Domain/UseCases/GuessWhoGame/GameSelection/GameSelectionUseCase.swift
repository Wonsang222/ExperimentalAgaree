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
    
    private let _targetGame: GameInfo
    private let _gameAuths: [AuthRepository]
    
    init(
        targetGame: GameInfo,
        gameAuths: [AuthRepository]
    ) {
        self._targetGame = targetGame
        self._gameAuths = gameAuths
    }
    
    func requestGameAuthorization() {
        for auth in _gameAuths {
            auth.reqAuth()
        }
    }
    
    func checkGameAuthrization(completion: @escaping (String?) -> Void) {
        var noAuthServiceDescription = [String]()
        for auth in _gameAuths {
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
        return _targetGame
    }
}
