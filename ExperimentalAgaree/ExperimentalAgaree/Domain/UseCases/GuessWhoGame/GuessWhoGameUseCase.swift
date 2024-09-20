//
//  GuessWhoGameUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/19/24.
//

import Foundation

// fetch
// gameStart

protocol CommonGameUseCase: GameUseCase {
    
    typealias FetchCompletion = (Result<Void, Error>) -> Void
    
    func fetch(requestValue: FetchGameModelUseCaseRequestValue,
               completion: @escaping FetchCompletion) -> Cancellable?
    func start()
    func end()
}

final class GuessWhoGameUseCase: CommonGameUseCase {
    
    private let fetchUseCase: FetchGameModelUseCase
    private let timerUseCase: TimerUsecase
    private let sttUseCase: STTUseCase
    
    private var gameModels: GameModelList?
    private var currentTargetModel: GameModel?
    // fetch model List
    // ready?
    // go!
    // right? -> next
    // no next? -> clear
    // timeOut -> fail
    
    init(
        fetchUseCase: FetchGameModelUseCase,
        timerUseCase: TimerUsecase,
        sttUseCase: STTUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.timerUseCase = timerUseCase
        self.sttUseCase = sttUseCase
    }
    
    func fetch(
        requestValue: FetchGameModelUseCaseRequestValue,
        completion: @escaping FetchCompletion
    ) -> Cancellable? {
        let fetchTask = fetchUseCase.fetch(requestValue: requestValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let modelList):
                self.gameModels = modelList
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
        return fetchTask
    }
    
    func startTimer(gameTimerValue: GameTimerValue) {
        let timerTask = timerUseCase.startTimer(gameTimerValue: gameTimerValue) { <#GameJudge<GameTimeInfo>#> in
            <#code#>
        }
    }
    
    func startRecognizer() {
        
    }
    
    func start() {
        
    }
    
    func right() {
        
    }
    
    func wrong() {
        
    }
    
    func judge() -> Bool {
        return true
    }
    
    func end() {
        
    }
}
