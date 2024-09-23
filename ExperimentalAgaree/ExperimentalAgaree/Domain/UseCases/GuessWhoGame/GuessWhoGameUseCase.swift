//
//  GuessWhoGameUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/19/24.
//

import Foundation

protocol CommonGameUseCase {
    
    typealias FetchCompletion = (Result<Void, Error>) -> Void
    typealias TimerCompletion = (GameJudge<GameTimeInfo>) -> Void
    typealias SttCompletion = (Result<GameJudge<Bool>, Error>) -> Void
    
    func fetch(requestValue: FetchGameModelUseCaseRequestValue,
               completion: @escaping FetchCompletion) -> Cancellable?
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping TimerCompletion) -> Cancellable?
    func startRecognizer(completion: @escaping SttCompletion) -> Cancellable?
}

final class GuessWhoGameUseCase: CommonGameUseCase {
    
    private let fetchUseCase: FetchGameModelUseCase
    private let timerUseCase: TimerUsecase
    private let sttUseCase: STTUseCase
    
    private var gameModels: GameModelList?
    private var currentTargetModel: GameModel?

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
        fetchUseCase.fetch(requestValue: requestValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let modelList):
                self.gameModels = modelList
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping TimerCompletion
    ) -> Cancellable? {
        timerUseCase.startTimer(gameTimerValue: gameTimerValue) { gameJudge in
            switch gameJudge {
            case .data(let timeInfo):
                completion(.data(timeInfo))
            case .wrong:
                completion(.wrong)
            }
        }
    }
    
    func startRecognizer(completion: @escaping SttCompletion) -> Cancellable? {
        let target = setTargetModel()
        return sttUseCase.startRecognition(target: target) { [weak self] result in
            switch result {
            case .success(let gameJudge):
                switch gameJudge {
                case .data(let gameStatus):
                    switch gameStatus {
                    case .Clear:
                        completion(.success(.data(true)))
                    case .Right:
                        self?.setTargetModel()
                    }
                case .wrong:
                    break
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    @discardableResult
    private func setTargetModel() -> GameModel? {
        self.currentTargetModel = gameModels?.last
        return self.currentTargetModel
    }
}
