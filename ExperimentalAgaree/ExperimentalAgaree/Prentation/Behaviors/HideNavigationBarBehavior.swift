//
//  BackBtnEmptyBehavior.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 11/19/24.
//

import UIKit

class HideNavigationBarBehavior: ViewControllerLifeCycleBehavior {
    func viewWillAppear(vc: UIViewController) {
        vc.navigationController?.navigationBar.isHidden = true
    }
    
    func viewWillDisappear(vc: UIViewController) {
        vc.navigationController?.navigationBar.isHidden = false
    }
}
