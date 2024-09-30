//
//  AppFlowCoordinator.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import UIKit

final class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let gameSceneDIContainer = appDIContainer
    }
}
