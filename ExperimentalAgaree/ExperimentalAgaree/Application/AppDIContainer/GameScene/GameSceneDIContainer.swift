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
    
    private func getAuths(for: GameInfo) -> [AuthorizationType] {
        
    }
    
    //MARK: - Game Selection
    
    func makeGameSelectionVC() {
        
    }
    
    func makeGameSelectionVM() {
        
    }
    
    func makeGameSelectionUseCase(gameInfo: GameInfo) -> GameSelectionUseCase {
        return DefaultGameSelectionUseCase(targetGame: gameInfo, gameAuths: <#T##[any AuthCheckable]#>)
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
