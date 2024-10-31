//
//  Alertable.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import UIKit


protocol Alertable { }

extension Alertable {
    var ext: Ext<Self> {
        get {
            return Ext(ext: self)
        }
    }
}

extension UIViewController: Alertable {}

extension Ext where T: UIViewController {
    func showAlert(
        title: String,
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        ext.present(alert, animated: true)
    }
}


