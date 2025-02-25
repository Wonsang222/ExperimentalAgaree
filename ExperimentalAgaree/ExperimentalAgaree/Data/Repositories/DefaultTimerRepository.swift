//
//  DefaultTimerRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/11/24.
//

import Foundation

final class DefaultTimerRepository: TimerRepository {
    
    private let timerService: TimerManager

    init(timerService: TimerManager) {
        self.timerService = timerService
    }
    
    func countGameTime(
        gameTime: Float,
        completion: @escaping (GameTimeInfo) -> Void
    ) -> Cancellable? {
        
        let timerTask = TimerTask()
        timerTask.task = timerService.startTimer(gameSec: gameTime) { second in
            let timerDomainModel = GameTimeInfo(gameTime: second)
            completion(timerDomainModel)
        }
        return timerTask
    }
}
