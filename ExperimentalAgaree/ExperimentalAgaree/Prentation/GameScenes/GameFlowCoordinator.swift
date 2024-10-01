//
//  GameFlowCoordinator.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

protocol GameFlowCoordinatorDependencies {
    func makeGuessWhoGameViewController() 
}

final class GameFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    func start() {
        
    }
}
