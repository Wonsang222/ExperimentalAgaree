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
    
#if DEBUG
    static func makeTempGameResultVM(isWin: Bool, action: GameResultViewModelAction) -> GameResultViewModel {
        return DefaultGameResultViewmodel(gameResultUseCase: makeGameTempResultUsecase(isWin: isWin), action: makeTempAction())
    }
    
    static func makeGameTempResultUsecase(isWin: Bool) -> GameResultUseCase {
        return DefaultGameResultUseCase(isWin: isWin)
    }
    
    static func makeTempAction() -> GameResultViewModelAction {
        return GameResultViewModelAction {
        }
    }
    
#endif
    
    func makeGameResultVC(isWin: Bool, action: GameResultViewModelAction) -> ResultController {
        return ResultController(resultViewModel: makeGameResultVM(isWin: isWin, action: action))
    }
    
    func makeGameResultVM(isWin: Bool, action: GameResultViewModelAction) -> GameResultViewModel {
        return DefaultGameResultViewmodel(gameResultUseCase: makeGameResultUsecase(isWin: isWin), action: action)
    }
    
    func makeGameResultUsecase(isWin: Bool) -> GameResultUseCase {
        return DefaultGameResultUseCase(isWin: isWin)
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
        DefaultGuessWhoViewModel(guessWhoUseCase: makeGuessWhoUseCase(gameInfo: game.gameInfo, auths: auths),
                                 actions: action,
                                 fetchData: game)
    }
    
    func makeGuessWhoUseCase(gameInfo: GameInfo, auths: [AuthRepository]) -> GuessWhoGameUseCase {
        
        let sortedAuths = sortAuths(with: auths)
        
        guard let audioRepository = sortedAuths.0,
              let sttRepository = sortedAuths.1 else { fatalError() }
        
        return GuessWhoGameUseCase(fetchUseCase: makeFetchUseCase(),
                                   timerUseCase: makeTimerUseCase(repository: makeTimerRepository()),
                                   sttUseCase: makeSTTUseCase(stt: sttRepository, audio: audioRepository))
    }
    
    private func sortAuths(with auths: [AuthRepository]) -> (AudioRecognizationRepository?, SttReqRepository?) {
        let audioRepository = auths.first { auth in
            auth is AudioRecognizationRepository
        } as? AudioRecognizationRepository
        
        let sttRepository = auths.first { auth in
            auth is SttReqRepository
        } as? SttReqRepository
        
        return (audioRepository, sttRepository)
    }
    
    func makeFetchUseCase() -> FetchGameModelUseCase {
        return DefaultFetchGameModelUseCase(gameRespository: makeFetchGameRepository(), _asyncRepository: makeAsyncFetchRepository())
    }
    
    func makeTimerUseCase(repository: TimerRepository) -> TimerUseCase {
        return DefaultGametimerUseCase(timerService: repository)
    }
    
    func makeSTTUseCase(stt: SttReqRepository, audio: AudioRecognizationRepository) -> STTUseCase {
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
    
    func makeTimerRepository() -> TimerRepository {
        return DefaultTimerRepository(timerService: dependencies.timerService)
    }
    
    //MARK: - Flow Coordinator
    
    func makeGameFlowCoordinator(navigationController: CustomUINavigationController) -> GameFlowCoordinator {
        return GameFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
