//
//  GuessWhoGameUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/19/24.
//

import Foundation

// 프로토콜 상속으로 했어야햇다

protocol CommonGameUseCase {
    
    typealias FetchCompletion = (Result<Void, Error>) -> Void
    typealias TimerCompletion = (GameJudge<GameTimeInfo>) -> Void
    typealias SttCompletion = (Result<GameJudge<Bool>, Error>) -> Void
    
    var targetModel: Observable<GameModelUsable?> { get }
    
    func fetch(requestValue: FetchGameModelUseCaseRequestValue,
               completion: @escaping FetchCompletion) -> Cancellable?
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping TimerCompletion) -> Cancellable?
    func startRecognizer(completion: @escaping SttCompletion) -> Cancellable?
}

final class GuessWhoGameUseCase: CommonGameUseCase {
    
    private let fetchUseCase: FetchGameModelUseCase
    private let _timerUseCase: TimerUseCase
    private let sttUseCase: STTUseCase
    
    private var gameModels = [GameModelUsable]()

    var targetModel: Observable<GameModelUsable?> = Observable(value: nil)

    init(
        fetchUseCase: FetchGameModelUseCase,
        timerUseCase: TimerUseCase,
        sttUseCase: STTUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self._timerUseCase = timerUseCase
        self.sttUseCase = sttUseCase
    }
    
    private func setClearGameModel() {
        self.gameModels.insert(GameClearModel(), at: 0)
    }
    
    private func replaceGameModelWithNullGameModel(from gameModels: [GameModelUsable]) -> [GameModelUsable] {
        var modelArr = gameModels
        for (idx, model) in modelArr.enumerated() {
            if model.photoBinary == nil {
                modelArr.insert(NullGameModel(), at: idx + 1)
                modelArr.remove(at: idx)
            }
        }
        return modelArr
    }
    
    func fetch(
        requestValue: FetchGameModelUseCaseRequestValue,
        completion: @escaping FetchCompletion
    ) -> Cancellable? {
        fetchUseCase.fetch(requestValue: requestValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let modelList):
                
                self.gameModels = self.replaceGameModelWithNullGameModel(from: modelList.models)
                setClearGameModel()
                setTargetModel()
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func startTimer(gameTimerValue: GameTimerValue,
                    completion: @escaping TimerCompletion
    ) -> Cancellable? {
        _timerUseCase.startTimer(gameTimerValue: gameTimerValue) { gameJudge in
            switch gameJudge {
            case .data(let timeInfo):
                completion(.data(timeInfo))
            case .wrong:
                completion(.wrong)
            }
        }
    }
    
    func startRecognizer(completion: @escaping SttCompletion) -> Cancellable? {
        
        // start model
        guard let targetModel = targetModel.getValue() else {
            fatalError("GuessWho UseCase Error")
        }
        
        return sttUseCase.startRecognition(target: targetModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gameJudge):
                if case .data(let gameStatus) = gameJudge {
                    if case .Clear = gameStatus {
                        completion(.success(.data(true)))
                    } else if case .Right = gameStatus {
                        self.setTargetModel() {
                            completion(.success(.data(false)))
                        }
                    }
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    private func setTargetModel(completion: (() -> Void)? = nil) {
        
        let nextTarget = getNext()
        if isFinished(by: nextTarget) {
            completion?()
            return
        }
        targetModel.setValue(nextTarget)
    }
    
    private func isFinished(by target: GameModelUsable) -> Bool {
        if target is GameClearModel {
            return true
        }
        return false
    }
    
    private func getNext() -> GameModelUsable {
        return gameModels.popLast()!
    }
}
