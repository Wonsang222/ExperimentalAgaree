//
//  TimerConfiguration.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/29/24.
//

import Foundation

protocol TimerConfigurable {
    var gameTime: Float { get }
    var timeInterval: Double { get }
    var isRepeat: Bool { get }
}

protocol TimerUsable {
    func fire()
    func invalidate()
}

extension Timer: TimerUsable {}

struct TimerConfiguration: TimerConfigurable {
    
    let gameTime: Float
    let timeInterval: Double
    let isRepeat: Bool
}
