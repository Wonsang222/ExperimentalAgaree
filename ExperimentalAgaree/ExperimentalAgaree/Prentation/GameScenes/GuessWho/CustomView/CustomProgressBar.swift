//
//  CustomProgressBar.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 2/10/25.
//

import UIKit

final class CustomProgressBar: UIView {
    private var prog: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func setProg(_ val: CGFloat) {
        self.prog = val
    }
    
    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: rect.midY)
        gradient.endPoint = CGPoint(x: 1, y: rect.midY)
        
        gradient.colors = [UIColor.blue.cgColor, UIColor.green.cgColor ,UIColor.red.cgColor]
        gradient.locations = [0, 0.5, 1]
        
        let width = rect.width * prog
        
        gradient.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width * prog, height: rect.height)
    }
}
