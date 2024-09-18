//
//  GameTimeInfo.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation

struct GameTimeInfo {
     var gameTime: Float
    
    init(gameTime: Float) {
        self.gameTime = gameTime
    }
    
    static func + (lhs: GameTimeInfo, rhs: GameTimeInfo) -> Self {
        return .init(gameTime: lhs.gameTime + rhs.gameTime )
    }
}
