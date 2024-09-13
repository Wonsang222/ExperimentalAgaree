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
    
}

final class DefaultGameTimerUsecase: GameTimerUseCase {
    
    private let timerService: TimerRepository
    
    init(timerService: TimerRepository) {
        self.timerService = timerService
    }

    
    
}
