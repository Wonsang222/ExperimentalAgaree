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
    
    func makeGameResultVC() {
        
    }
    
    func makeGameResultVM() {
        
    }
    
    func makeGameResultUsecase() {
        
    }
    
    //MARK: - Game (GuessWho)
    
    func makeGuessWhoVC() {
        
    }
    
    func makeGuessWhoVM() {
        
    }
    
    func makeGuessWhoUseCase() {
        
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
    
    //MARK: - Flow Coordinator
    
    func makeGameFlowCoordinator() {
        
    }
}
