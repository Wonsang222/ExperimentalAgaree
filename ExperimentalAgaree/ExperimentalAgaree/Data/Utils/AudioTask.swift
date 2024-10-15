//
//  AudioTask.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/15/24.
//

import Foundation

final class AudioTask: Cancellable {
    
    var task: AgareeAudio? = nil
    
    func cancel() {
        
        task = nil
    }
}
