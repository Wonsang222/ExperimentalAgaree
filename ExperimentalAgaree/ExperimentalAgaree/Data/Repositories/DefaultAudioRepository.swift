//
//  DefaultAudioRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/15/24.
//

import Foundation

final class DefaultAudioRepository: AudioRepository {
    
    private let service: AudioEngineService
    private var audioEngine: AudioEngineUsable?
    
    init(service: AudioEngineService) {
        self.service = service
    }
    
    func startRecognition(completion: @escaping Completion) -> Cancellable? {
        
        let audio = AudioTask()
        
        audioEngine = service.activateAudioEngine(completion: { result in
            switch result {
            case .success(let audioBufferDTO):
                completion(.success(audioBufferDTO))
            case .failure(let err):
                completion(.failure(err))
            }
        })
        
        audio.task = audioEngine
        
        return audio
    }
    
    func checkAuth(completion: @escaping (Bool) -> Void) {
        service.checkAuthorizatio { result in
            completion(result)
        }
    }
    
    func reqAuth() {
        service.requestAuthorization()
    }
}
