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
    ) -> TimerUsable? {
        
        return timerService.startTimer(gameSec: gameTime,
                                       handlerQueue: .main) { second in
            let timerDomainModel = GameTimeInfo(gameTime: second)
            completion(timerDomainModel)
        }
    }
}
