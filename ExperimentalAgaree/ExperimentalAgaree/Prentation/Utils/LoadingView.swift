//
//  LoadingView.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import UIKit

class LoadingView {
    static var spinner: UIActivityIndicatorView?
    
    static func show() {
        DispatchQueue.main.async {
            if spinner == nil,
               let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                let frame = window.bounds
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = .black.withAlphaComponent(0.2)
                spinner.style = .large
                window.addSubview(spinner)
                
                spinner.startAnimating()
                
                self.spinner = spinner
            }
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            guard let spinner = spinner else { return }
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.spinner = nil
        }
    }
}
