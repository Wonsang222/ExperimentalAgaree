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
        gameInfo: Float,
        completion: @escaping (GameTimeInfo) -> Void
    ) -> GameJudgeable? {
        <#code#>
    }
    
    func stopTimer() {
        <#code#>
    }
    
    func resetTimer() {
        <#code#>
    }
    
}
