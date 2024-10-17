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
   
    //MARK: - Repositories
    
    func makeSTTRepository() {
        
    }
    
    func makeAudioRepository() {
        
    }
    
    func makeFetchGameRepository() {
        
    }
    
    //MARK: - Flow Coordinator
    
    func makeGameFlowCoordinator() {
        
    }
}
