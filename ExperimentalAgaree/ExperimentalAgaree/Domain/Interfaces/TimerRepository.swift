//
//  TimerRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/26/24.
//

import Foundation



protocol TimerRepository {
    
    func countGameTime(
        gameInfo: Float,
        completion: @escaping (GameTimeInfo) -> Void 
    ) -> GameJudgeable?
    
    func stopTimer()
    
    func resetTimer()
}
