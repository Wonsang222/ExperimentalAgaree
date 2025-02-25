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
    func resetTimerInfo()
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
            if strongSelf.judge(by: 1.0) {
                completion(.data(timerInfo))
            } else {
                completion(.wrong)
            }
        }
    }
    
    func resetTimerInfo() {
        _currentTimer = GameTimeInfo(gameTime: 0.0)
    }

    private func judge(by gametime: Float) -> Bool {
        // time out
        if _currentTimer.gameTime >= gametime {
            return false
        }
        return true
    }
}
