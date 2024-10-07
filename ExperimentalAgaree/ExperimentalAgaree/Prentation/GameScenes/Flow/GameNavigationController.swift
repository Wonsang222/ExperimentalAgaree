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
    }
}
