//
//  Game_timerUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/12/24.
//

import Foundation

struct GameTimerValue {
    let gameTime: Float
}

protocol TimerUseCase {
    typealias Completion = (GameJudge<GameTimeInfo>) -> Void
    
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping Completion
    ) -> Cancellable?
}

final class DefaultGametimerUseCase: TimerUseCase {
    
    private var _currentTimer: GameTimeInfo = GameTimeInfo(gameTime: 0.0)
    private let _timerService: TimerRepository

    init(timerService: TimerRepository) {
        self._timerService = timerService
    }
    
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping Completion
    ) -> Cancellable? {
        _timerService.countGameTime(gameTime: gameTimerValue.gameTime) { [weak self] timerInfo in
            guard let strongSelf = self else  { return }
            strongSelf._currentTimer = strongSelf._currentTimer + timerInfo
            if strongSelf.judge() {
                completion(.data(timerInfo))
            } else {
                completion(.wrong)
            }
        }
    }

    private func judge() -> Bool {
        // time out
        if _currentTimer.gameTime >= 1.0 {
            return false
        }
        return true
    }
}
