//
//  CustomProgressView.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 1/17/25.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

final class CustomProgressView: UIView {
    
    private var progress: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
    }
}
