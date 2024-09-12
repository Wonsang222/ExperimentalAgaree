//
//  TimerTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/12/24.
//

import Foundation

final class TimerTask: GameJudgeable {
    
    var stack: Float = 0.0
    let timer: TimerUsable
    
    init(timer: TimerUsable) {
        self.timer = timer
    }
    
    func right() {
        
    }
    
    func wrong() {
        
    }
}
