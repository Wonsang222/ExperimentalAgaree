//
//  SpeechTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/1/24.
//

import Foundation
import Speech

enum SpeechError: Error {
    
}

protocol SpeechTaskUsable {
    
    typealias Completion = (Result<String,SpeechError>) -> Void
    
    func request(
        config: AudioSessionCofigurable,
        on queue: DataTransferDispatchQueue,
        completion: @escaping Completion
    ) -> SFSpeechRecognitionTask?
    
    func stop()
}



final class DefaultSpeechManager: SpeechTaskUsable {
    
    let config: AudioSessionCofigurable
    let audioEngine: AudioEngineUsable
    let completionQueue: DataTransferDispatchQueue
    
    init(
        config: AudioSessionCofigurable,
        audioEngine: AudioEngineUsable = AudioEngineManager(),
        completionQueue: DataTransferDispatchQueue = DispatchQueue.main ) {
        self.config = config
        self.completionQueue = completionQueue
    }
    
    func request(config: any AudioSessionCofigurable,
                 on queue: any DataTransferDispatchQueue,
                 completion: @escaping Completion
    ) -> SFSpeechRecognitionTask? {
        let engine = audioEngine.activateAudioEngine(config: config) { result in
            switch result {
            case .success(let buffer):
                print(123)
            case .failure(let err):
                print(123)
            }
        }
    }
    
    func stop() {
        <#code#>
    }
    
    
}
