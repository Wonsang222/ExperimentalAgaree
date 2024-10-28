//
//  AppFlowCoordinator.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

final class AppFlowCoordinator {
    
    var navigationController: CustomUINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: CustomUINavigationController,
         appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let gameSceneDIContainer = appDIContainer.makeGameSceneDIContainer()
        let flow = gameSceneDIContainer.makeGameFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
