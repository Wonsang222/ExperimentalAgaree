//
//  UIProgressView + Timer.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 12/12/24.
//

import UIKit

final class TimerProgresssView: UIProgressView {
    private var stackedNumber: Float = 0.0
    
    func reset() {
        stackedNumber = 0
    }
    
    override func setProgress(_ progress: Float, animated: Bool) {
        stackedNumber += progress
        super.setProgress(stackedNumber, animated: animated)
    }
}
