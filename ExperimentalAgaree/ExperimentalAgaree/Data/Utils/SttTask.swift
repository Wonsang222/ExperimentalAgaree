//
//  SttTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/17/24.
//

import Foundation

class SttTask: Cancellable {
    
    var task: SpeechTaskUsable? = nil
    
    func cancel() {
        task?.stop()
        task = nil
    }
}
