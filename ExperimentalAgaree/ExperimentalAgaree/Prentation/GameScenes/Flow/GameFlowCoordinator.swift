//
//  GameFlowCoordinator.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

protocol GameFlowCoordinatorDependencies {
    func makeGameSelectionVC(game: GameInfo, action: GameSelectionViewModelAction) -> PreGameController
}

final class GameFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: GameFlowCoordinatorDependencies
    
    init(
        navigationController: UINavigationController?,
         dependencies: GameFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(with game: GameInfo = GameInfo(gamePath: .guessWho, numberOfPlayers: 2)) {
        let gameSelectionAction = GameSelectionViewModelAction(goPlayGame: goPlayGame)
        let gameSelectionVC = dependencies.makeGameSelectionVC(game: game, action: gameSelectionAction)
        navigationController?.pushViewController(gameSelectionVC, animated: true)
    }
    
    private func goBackToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func goPlayGame(gameInfo: GameInfo) {
        
    }
    
    private func showResultVC(isWin: Bool) {
        
    }
}
