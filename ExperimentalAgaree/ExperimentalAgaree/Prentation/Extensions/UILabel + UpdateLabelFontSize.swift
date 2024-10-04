//
//  UILabel + UpdateLabelFontSize.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/4/24.
//

import UIKit

extension UILabel {
    func updateLabelFontSize(view: UIView) {
        let maxSize: CGFloat = 150
        self.font = .systemFont(ofSize: maxSize)
        self.sizeToFit()
        
        while self.bounds.width > view.bounds.width || self.bounds.height > view.bounds.height {
            let currentFontSize = self.font.pointSize
            let reducedSize = currentFontSize - 1.0
            
            if reducedSize < UIFont.labelFontSize {
                break
            }
            
            self.font = .systemFont(ofSize: reducedSize)
            self.sizeToFit()
        }
    }
}
