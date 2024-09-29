//
//  GameTimerUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/12/24.
//

import Foundation

struct GameTimerValue {
    let gameTime: Float
}

protocol TimerUsecase {
    typealias Completion = (GameJudge<GameTimeInfo>) -> Void
    
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping Completion
    ) -> Cancellable?
}

final class DefaultGameTimerUsecase: TimerUsecase {
    
    private var currentTimer: GameTimeInfo
    private let timerService: TimerRepository

    init(timerService: TimerRepository, currentTimer: GameTimeInfo) {
        self.timerService = timerService
        self.currentTimer = currentTimer
    }
    
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping Completion
    ) -> Cancellable? {
        timerService.countGameTime(gameTime: gameTimerValue.gameTime) { [weak self] timerInfo in
            guard let strongSelf = self else  { return }
            strongSelf.currentTimer = strongSelf.currentTimer + timerInfo
            if strongSelf.judge() {
                completion(.data(timerInfo))
            } else {
                completion(.wrong)
            }
        }
    }

    private func judge() -> Bool {
        // time out
        if currentTimer.gameTime >= 1.0 {
            return false
        }
        return true
    }
}
