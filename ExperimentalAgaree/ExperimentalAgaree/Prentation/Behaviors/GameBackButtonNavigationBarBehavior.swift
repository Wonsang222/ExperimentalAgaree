//
//  GameBackButtonNavigationBarBehavior.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/7/24.
//

import UIKit

final class GameBackButtonNavigationBarBehavior: ViewControllerLifeCycleBehavior {
    
    func viewDidLoad(vc: UIViewController) {
        
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .plain, target: vc, action: nil)
        vc.navigationController?.isNavigationBarHidden = true
    }
}
