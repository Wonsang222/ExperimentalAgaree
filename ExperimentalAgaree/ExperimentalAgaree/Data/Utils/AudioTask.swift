//
//  AudioTask.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/15/24.
//

import Foundation

final class AudioTask: Cancellable {
    
    var task: AudioEngineBuilder? = nil
    
    func cancel() {
        task = nil
    }
}
