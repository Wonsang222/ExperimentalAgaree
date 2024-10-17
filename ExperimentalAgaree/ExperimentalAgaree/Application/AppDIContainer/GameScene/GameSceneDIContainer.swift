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
    
    func makeGameSelectionVC() {
        
    }
    
    func makeGameSelectionVM() {
        
    }
    
    func makeGameSelectionUseCase() {
        
    }
    
    //MARK: - GameResult
    
    func makeGameResultVC() {
        
    }
    
    func makeGameResultVM() {
        
    }
    
    func makeGameResultUsecase() {
        
    }
    
    //MARK: - Repositories
    
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
