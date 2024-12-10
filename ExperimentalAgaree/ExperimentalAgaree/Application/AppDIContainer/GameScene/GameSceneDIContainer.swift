//
//  GameSceneDIContainer.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

final class GameSceneDIContainer: GameFlowCoordinatorDependencies {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let asyncDataTrasnferService: AsyncGroupDatatransferService
        let sttService: SpeechTaskUsable
        let timerService: TimerManager
        let audioService: AudioEngineBuilder
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: - Game Selection
    
    func makeGameSelectionVC(game: GameInfo, action: GameSelectionViewModelAction) -> PreGameController {
        return PreGameController(gameSelectionViewModel: makeGameSelectionVM(game: game, action: action))
    }
    
    func makeGameSelectionVM(game: GameInfo, action: GameSelectionViewModelAction) -> GameSelectionViewModel {
        return DefaultGameSelectionViewModel(useCase: makeGameSelectionUseCase(gameInfo: game), action: action)
    }
    
    func makeGameSelectionUseCase(gameInfo: GameInfo) -> GameSelectionUseCase {
        return DefaultGameSelectionUseCase(targetGame: gameInfo, gameAuths: makeGameAuths(by: gameInfo))
    }
    
    private func makeGameAuths(by gameInfo: GameInfo) -> [AuthRepository] {
        var authList = [AuthRepository]()
        let auths = gameInfo.getGamePath().auths
        for auth in auths {
            switch auth {
            case .internet:
                break
            case .mic:
                authList.append(makeAudioRepository() as AuthRepository)
            case .stt:
                authList.append(makeSTTRepository() as AuthRepository)
            }
        }
        return authList
    }
    
    //MARK: - GameResult
    
    func makeGameResultVC(isWin: Bool) {
        
    }
    
    func makeGameResultVM() {
        
    }
    
    func makeGameResultUsecase() {
        
    }
    
    //MARK: - Game (GuessWho)
    
    func makeGuessWhoVC(game: FetchGameModelUseCaseRequestValue,
                        action: GuessWhoViewModelAction,
                        auths: [AuthRepository]
    ) -> GuessWhoController {
        let vc = GuessWhoController(gameViewModel: makeGuessWhoVM(game: game,
                                                                  action: action,
                                                                  auths: auths))
        return vc
    }
    
    func makeGuessWhoVM(game: FetchGameModelUseCaseRequestValue,
                        action: GuessWhoViewModelAction,
                        auths: [AuthRepository]
    ) -> GuessWhoViewModel {
        DefaultGuessWhoViewModel(guessWhoUseCase: makeGuessWhoUseCase(auths: auths),
                                 actions: action,
                                 fetchData: game)
    }
    
    func makeGuessWhoUseCase(auths: [AuthRepository]) -> GuessWhoGameUseCase {
        
        let sortedAuths = sortAuths(with: auths)
        guard let timerUsecase = sortedAuths.0,
              let sttUseCase = sortedAuths.1 else { fatalError() }
        
        
        return GuessWhoGameUseCase(fetchUseCase: <#T##FetchGameModelUseCase#>,
                                   timerUseCase: timerUsecase,
                                   sttUseCase: sttUseCase)
    }
    
    private func sortAuths(with auths: [AuthRepository]) -> (TimerUseCase?, STTUseCase?) {
        let timerUseCase = auths.first { auth in
            auth is TimerUseCase
        } as? TimerUseCase
        
        let sttUseCase = auths.first { auth in
            auth is STTUseCase
        } as? STTUseCase
        
        return (timerUseCase, sttUseCase)
    }
    
    func makeFetchUseCase() -> FetchGameModelUseCase {
        
    }
    
    func makeTimerUseCase(repository: TimerRepository) -> TimerUseCase {
        return DefaultGametimerUseCase(timerService: repository)
    }
    
    func makeSTTUseCase(stt: STTRepository, audio: AudioRepository) -> STTUseCase {
        return DefaultSTTUseCase(sttService: stt , audioService: audio)
    }
    
    //MARK: - Repositories
    
    func makeSTTRepository() -> STTRepository  {
        return DefaultSTTRepository(sttService: dependencies.sttService)
    }
    
    func makeAudioRepository() -> AudioRepository {
        return DefaultAudioRepository(service: dependencies.audioService)
    }
    
    func makeFetchGameRepository() -> GamesRepository {
        return DefaultGamesRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeAsyncFetchRepository() -> GameModelImageRepository {
        return DefaultGameModelImageRepository(_groupDataTransferService: dependencies.asyncDataTrasnferService)
    }
    
    //MARK: - Flow Coordinator
    
    func makeGameFlowCoordinator(navigationController: CustomUINavigationController) -> GameFlowCoordinator {
        return GameFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
