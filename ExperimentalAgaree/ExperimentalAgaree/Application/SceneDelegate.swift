//
//  SceneDelegate.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/21/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let navigation = CustomUINavigationController()
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigation
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigation,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    }
}

