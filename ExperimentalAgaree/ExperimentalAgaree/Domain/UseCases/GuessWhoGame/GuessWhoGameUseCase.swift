//
//  GuessWhoGameUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/26/24.
//




import Foundation


///  Actions
///  Start()  -
final class GuessWhoGameUseCase: GameUseCase {
    
    private let gamesRepository: GamesRepository
    private let timerRepository: TimerRepository
    
    init(
        gamesRepository: GamesRepository,
        timerRepository: TimerRepository
    ) {
        self.gamesRepository = gamesRepository
        self.timerRepository = timerRepository
    }
    
    func start(info: GameInfo) -> Cancellable? {
        let task = gamesRepository.fetchCharacterList(query: info) { models in
            
        }
        return task
    }
    
    func judge() -> Bool {
        return true
    }
    
    
}
