//
//  GameSceneDIContainer.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

final class GameSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let sttService: SpeechTaskUsable
        let timerService: TimerManager
        let audioService: AudioEngineUsable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: - VC
    func makeGuessWhoVC(gamereqInfo: FetchGameModelUseCaseRequestValue, actions: GuessWhoViewModelAction) {
        
    }
    
    //MARK: - ViewModel
    private func makeGuessWhoViewModel(gameReqInfo: FetchGameModelUseCaseRequestValue, actions: GuessWhoViewModelAction) -> GuessWhoViewModel {
        return DefaultGuessWhoViewModel(guessWhoUseCase: makeGuessWhoUseCase(), actions: actions, fetchData: gameReqInfo)
    }
    
    //MARK: - USECASE
    
    private func makeGuessWhoUseCase() -> GuessWhoGameUseCase {
        return GuessWhoGameUseCase(fetchUseCase: makeFetchUseCase(), timerUseCase: makeTimerUseCase(), sttUseCase: makeSTTUseCase())
    }
    
    private func makeFetchUseCase() -> FetchGameModelUseCase {
        return DefaultFetchGameModelUseCase(gameRespository: makeGameRepository())
    }
    
    private func makeTimerUseCase() -> TimerUsecase {        
        return DefaultGameTimerUsecase(timerService: makeTimerRepository())
    }
    
    private func makeSTTUseCase() -> STTUseCase {
        return DefaultSTTUseCase(sttService: makeSTTRepository())
    }
    
    //MARK: - Repository
    
    private func makeGameRepository() -> GamesRepository {
        return DefaultGamesRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    private func makeSTTRepository() -> STTRepository {
        return DefaultSTTRepository(sttService: dependencies.sttService)
    }
    
    private func makeTimerRepository() -> TimerRepository {
        return DefaultTimerRepository(timerService: dependencies.timerService)
    }
    
    private func makeMICAuthRepository() -> AuthCheckable {
        return AudioEngineManager(audioSessionConfig: <#T##any AudioSessionCofigurable#>)
    }
}
