//
//  UIVC + AddBehaviors.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import UIKit

@objc protocol ViewControllerLifeCycleBehavior {
    @objc optional func viewDidLoad(vc: UIViewController)
    @objc optional func viewWillAppear(vc: UIViewController)
    @objc optional func viewWillLayoutSubviews(vc: UIViewController)
    @objc optional func viewDidLayoutSubviews(vc: UIViewController)
    @objc optional func viewDidAppear(vc: UIViewController)
    @objc optional func viewWillDisappear(vc: UIViewController)
    @objc optional func viewDidDisappear(vc: UIViewController)
}

extension UIViewController {
    
    func addBehaviors(_ behaviors: [ViewControllerLifeCycleBehavior]) {
        let innerVC = LifeCycleBehaviorViewController(behaviors: behaviors)
        addChild(innerVC)
        view.addSubview(innerVC.view)
        innerVC.didMove(toParent: self)
    }
    
    private final class LifeCycleBehaviorViewController: UIViewController {
        private let behaviors: [ViewControllerLifeCycleBehavior]
        
        init(behaviors: [ViewControllerLifeCycleBehavior]) {
            self.behaviors = behaviors
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private var outerParent: UIViewController {
            return parent ?? UIViewController(nibName: nil, bundle: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.isHidden = true
            applyBehaviours { behavior, vc in
                behavior.viewDidLoad?(vc: vc)
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            applyBehaviours { behavior, vc in
                behavior.viewWillAppear?(vc: vc)
            }
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            applyBehaviours { behavior, vc in
                behavior.viewWillLayoutSubviews?(vc: vc)
            }
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            applyBehaviours { behavior, vc in
                behavior.viewDidLayoutSubviews?(vc: vc)
            }
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            applyBehaviours { behavior, vc in
                behavior.viewWillDisappear?(vc: vc)
            }
        }
        
        private func applyBehaviours(body: (_ behavior:ViewControllerLifeCycleBehavior,_ vc: UIViewController) -> Void) {
            for behavior in behaviors {
                body(behavior, outerParent)
            }
        }
    }
}
