//
//  AppFlowCoordinator.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

final class AppFlowCoordinator {
    
    var navigationController: CustomUINavigationController
    var window: UIWindow
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: CustomUINavigationController,
         appDIContainer: AppDIContainer,
        window: UIWindow
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.window = window
    }
    
    func start() {
        window.rootViewController = navigationController
        let gameSceneDIContainer = appDIContainer.makeGameSceneDIContainer()
        let flow = gameSceneDIContainer.makeGameFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
