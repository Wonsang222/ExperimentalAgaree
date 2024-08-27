//
//  GuessWhoGameUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/26/24.
//

import Foundation


///  Actions
///  1. fetch
///  2. start
///  3. judge
final class GuessWhoGameUseCase: GameUseCase {

    private let gamesRepository: GamesRepository
    private let timerRepository: TimerRepository
    private let sttRepository: STTRepository
    private let fetchingArgument: ((GameInfo) -> Void) -> Void
    
    init(
        gamesRepository: GamesRepository,
        timerRepository: TimerRepository,
        sttRepository: STTRepository,
        fetchingArgument: @escaping ((GameInfo) -> Void) -> Void
    ) {
        self.gamesRepository = gamesRepository
        self.timerRepository = timerRepository
        self.sttRepository = sttRepository
        self.fetchingArgument = fetchingArgument
    }
    
    func fetch() -> (any Cancellable)? {

        fetchingArgument { gameInfo in
            gamesRepository.fetchCharacterList(query: gameInfo) { result in
                switch result {
                case .success(let gameModel):
                    print(123)
                case .failure(let error):
                    print(123)
                }
            }
        }
    }
    
    func start() {
        
    }
    
    func judge() -> Bool {
        
    }
    
}
