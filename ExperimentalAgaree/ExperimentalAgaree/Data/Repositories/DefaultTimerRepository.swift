//
//  DefaultTimerRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/11/24.
//

import Foundation

final class DefaultTimerRepository: TimerRepository {
    
    private let timerService: TimerManager
    private var backUp: (gameTime: Float, completion: (GameTimeInfo) -> Void)?
    
    init(timerService: TimerManager) {
        self.timerService = timerService
    }
    
    func countGameTime(
        gameTime: Float,
        completion: @escaping (GameTimeInfo) -> Void
    ) -> TimerUsable? {
        
        backUp = (gameTime, completion)
    
        return timerService.startTimer(gameSec: gameTime, handlerQueue: .main) { [weak self] second in
            guard let strongSelf = self else { return }
            let responseDTO = strongSelf.generateTimerResponseDTO(second: second)
            completion(responseDTO)
        }
    }

    func resetTimer() {
        guard let backUp = backUp else { return }
    
        timerService.startTimer(gameSec: backUp.gameTime, handlerQueue: .main) { [weak self] second in
            guard let strongSelf = self else { return }
            let responseDTO = strongSelf.generateTimerResponseDTO(second: second)
            backUp.completion(responseDTO)
            self?.backUp = nil
        }
    }
    
    private func generateTimerResponseDTO(second: Float) -> GameTimeInfo {
        return .init(emit: second)
    }
}
