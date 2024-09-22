//
//  TimerTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/21/24.
//

import Foundation

final class TimerTask: Cancellable {
    var task: TimerUsable?
    
    func cancel() {
        task?.invalidate()
        task = nil
    }
}
