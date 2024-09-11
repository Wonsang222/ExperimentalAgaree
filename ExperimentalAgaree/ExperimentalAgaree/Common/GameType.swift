//
//  GameType.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/3/24.
//

import Foundation

class GameInfo {
    let gamePath: GameType
    let numberOfPlayers: UInt8
    
    init(
        gamePath: GameType,
        numberOfPlayers: UInt8
    ) {
        self.gamePath = gamePath
        self.numberOfPlayers = numberOfPlayers
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
