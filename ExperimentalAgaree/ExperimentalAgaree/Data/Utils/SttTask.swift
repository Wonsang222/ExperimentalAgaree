//
//  SttTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/17/24.
//

import Foundation

class SttTask: Cancellable {
    
    var task: SttTaskCancellable? = nil
    
    func cancel() {
        task?.cancel()
        task = nil
    }
}
