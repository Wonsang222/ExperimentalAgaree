//
//  GameTimerUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/12/24.
//

import Foundation

struct GameTimerValue {
    let gameSec: Float
}

protocol GameTimerUseCase {
    typealias Completion = (GameTimeInfo) -> Void
    
    func startTimer(
        gameTimerValue: GameTimerValue
        ,completion: @escaping Completion
    ) -> GameJudgeable?
    
    func resetTimer()
}

final class DefaultGameTimerUsecase: GameTimerUseCase {
    
    private let timerService: 
    
    func startTimer(
        gameTimerValue: GameTimerValue,
        completion: @escaping Completion
    ) -> GameJudgeable? {
        
    }
    
    func resetTimer() {
        
    }
    
    
}
