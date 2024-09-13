//
//  TimerTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/12/24.
//

import Foundation

final class TimerTask: GameJudgeable {
    
    private var ticktock : Float = 0.0 {
        didSet {
            wrong()
        }
    }
    private let timer: TimerUsable
    
    init(timer: TimerUsable) {
        self.timer = timer
    }
    
    func right() {
        timer.invalidate()
        timer.fire()
    }
    
    func wrong() {
        
    }
}
