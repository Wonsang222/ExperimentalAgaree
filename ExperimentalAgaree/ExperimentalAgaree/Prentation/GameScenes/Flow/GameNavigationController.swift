//
//  GameNavigationController.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/7/24.
//

import UIKit

final class CustomUINavigationController: UINavigationController{

    override var childForStatusBarStyle: UIViewController?{
        return topViewController
    }
    
    override var childForStatusBarHidden: UIViewController?{
        return topViewController
    }
    
    override func viewDidLoad() {
        // minimum sdk ios 15
        let standard = UINavigationBarAppearance()
        standard.configureWithTransparentBackground()
        standard.setBackIndicatorImage(UIImage(named: "back_icon"), transitionMaskImage: UIImage(named: "back_icon"))
        
        navigationBar.standardAppearance = standard
        navigationBar.scrollEdgeAppearance = standard
    }
}
