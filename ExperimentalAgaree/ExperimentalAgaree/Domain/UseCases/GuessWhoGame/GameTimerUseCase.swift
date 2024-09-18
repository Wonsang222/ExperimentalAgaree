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

protocol GameUseCase {
    func right()
    func wrong()
    func judge() -> Bool
}

protocol GameTimerUseCase: GameUseCase {
    typealias Completion = (GameTimeInfo) -> Void
    
    func startTimer(
        gameTimerValue: GameTimerValue
        ,completion: @escaping Completion
    ) -> TimerUsable?
}

final class DefaultGameTimerUsecase: GameTimerUseCase {
    
    private var currentTimer: GameTimeInfo
    private let timerService: TimerRepository
    
    private var rightCompletion: (() -> Void)?
    private var wrongCompletion: (() -> Void)?
    
    init(timerService: TimerRepository, currentTimer: GameTimeInfo) {
        self.timerService = timerService
        self.currentTimer = currentTimer
    }
    
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping Completion
    ) -> (any TimerUsable)? {
        timerService.countGameTime(gameTime: gameTimerValue.gameTime) { [weak self] timerInfo in
            guard let strongSelf = self else  { return }
            strongSelf.currentTimer = strongSelf.currentTimer + timerInfo
            if strongSelf.judge() {
                completion(timerInfo)
                return
            }
            strongSelf.wrong()
        }
    }
    
    func right() {
        rightCompletion?()
    }
    
    func wrong() {
        wrongCompletion?()
    }
    
    func judge() -> Bool {
        if currentTimer.gameTime >= 1.0 {
            return false
        }
        return true
    }
}
