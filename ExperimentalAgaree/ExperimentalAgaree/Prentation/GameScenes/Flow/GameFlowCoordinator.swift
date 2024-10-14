//
//  GameFlowCoordinator.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

protocol GameFlowCoordinatorDependencies {
    func makeGameSelectionViewController() -> PreGameController
    func makeGuessWhoGameViewController(action: GuessWhoViewModelAction) -> GuessWhoController
    func makeResultController(result: Bool) -> ResultController
    func goBackToRootVC()
}

final class GameFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: GameFlowCoordinatorDependencies
    
    private weak var resultVC: ResultController?
    
    init(
        navigationController: UINavigationController?,
         dependencies: GameFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
        
    }
    
    private func showResult(result: Bool) {
        let vc = dependencies.makeResultController(result: result)
        resultVC = vc
        navigationController?.pushViewController(resultVC!, animated: true)
    }
    
    private func goBackToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func goPlayGame(gameInfo: FetchGameModelUseCaseRequestValue, actions: GuessWhoViewModelAction) -> GuessWhoController {
        return GuessWhoController()
    }
}
