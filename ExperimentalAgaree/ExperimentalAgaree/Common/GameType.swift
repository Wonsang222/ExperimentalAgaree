//
//  GameType.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/3/24.
//

import Foundation

final class GameInfo {
    let gamePath: GameType
    let numberOfPlayers: UInt8
    let gameTime: GameTimerValue
    
    init(
        gamePath: GameType,
        numberOfPlayers: UInt8,
        gameTime: GameTimerValue = GameTimerValue(gameTime: 5.0)
    ) {
        self.gamePath = gamePath
        self.numberOfPlayers = numberOfPlayers
        self.gameTime = gameTime
    }
}

enum GameType: String {
    case guessWho
    
    var description: String {
        switch self {
        case .guessWho:
            return "인물퀴즈"
        }
    }
}
