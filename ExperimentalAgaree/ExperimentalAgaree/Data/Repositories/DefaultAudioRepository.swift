//
//  DefaultAudioRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/15/24.
//

import Foundation

final class DefaultAudioRepository: AudioRepository {
    
    private let service: AudioEngineBuilderService
    
    init(service: AudioEngineBuilderService) {
        self.service = service
    }
    
    func startRecognition(completion: @escaping Completion) {
        
        checkAuth { [weak self] isAuthorized in
            if isAuthorized {
                self?.service.start { result in
                    switch result {
                    case .success(let audioBufferDTO):
                        completion(.success(audioBufferDTO))
                    case .failure(let audioErr):
                        completion(.failure(audioErr))
                    }
                }
            }
        }
    }
    
    func stop() {
        service.stop()
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
