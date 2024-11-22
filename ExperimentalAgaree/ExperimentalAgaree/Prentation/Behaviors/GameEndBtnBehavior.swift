//
//  GameEndBtnBehavior.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 11/19/24.
//

import UIKit

final class GameEndBtnBehavior: ViewControllerLifeCycleBehavior {
    func viewDidLoad(vc: UIViewController) {
        vc.navigationItem.leftBarButtonItem = nil
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: nil, action: nil)
    }
}
