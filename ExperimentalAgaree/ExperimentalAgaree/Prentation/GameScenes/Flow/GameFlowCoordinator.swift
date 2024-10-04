//
//  GameFlowCoordinator.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

protocol GameFlowCoordinatorDependencies {
    func makeGameSelectionViewController() -> UIViewController
    func makeGuessWhoGameViewController(action: GuessWhoViewModelAction) -> UIViewController
    func makeResultController(result: Bool) -> ResultController
    func goBackToRootVC()
}

final class GameFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: GameFlowCoordinatorDependencies
    
    private weak var resultVC: ResultController?
    
    init(
        navigationController: UINavigationController? = nil,
         dependencies: GameFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
    }
    
    
    private func showResult(result: Bool) {
        
        // action goBackTorootVC 주입
        
        let vc = dependencies.makeResultController(result: result)
        resultVC = vc
        navigationController?.pushViewController(resultVC!, animated: true)
    }
    
    private func goBackToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
}
