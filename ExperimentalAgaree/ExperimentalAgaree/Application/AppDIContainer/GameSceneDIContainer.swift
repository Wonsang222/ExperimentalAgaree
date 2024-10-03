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
    
    func makeGameSceneDIContainer(navigation: UINavigationController) -> GameFlowCoordinator {
        GameFlowCoordinator(navigationController: navigation)
    }
    
}
