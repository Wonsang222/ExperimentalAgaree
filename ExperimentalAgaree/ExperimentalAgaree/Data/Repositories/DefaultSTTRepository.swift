//
//  DefaultSTTRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/15/24.
//

import Foundation
import AVFoundation

final class DefaultSTTRepository: STTRepository {
    private var sttService: SpeechTaskUsable
    private let executionQueue: DataTransferDispatchQueue
    
    var description: String {
        sttService.getDescription()
    }
    
    init(sttService: SpeechTaskUsable,
         executionQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.sttService = sttService
        self.executionQueue = executionQueue
    }
    
    func startRecognition(completion: @escaping Completion
    ) -> Cancellable?
    {
            let sttTask = SttTask()
            sttTask.task = sttService.request(on: executionQueue, completion: { result in
                switch result {
                case .success(let char):
                    completion(.success(.init(word: char)))
                case .failure(let sttErr):
                    completion(.failure(sttErr))
                }
            })
            return sttTask
    }
    
    func appendAudioBufferToSttRequest(buffer:  AVAudioPCMBuffer) {
        sttService.appendRecogRequest(buffer)
    }
    
    func checkAuth(completion: @escaping (Bool) -> Void) {
        sttService.checkAuthorizatio(completion: completion)
    }
    
    func reqAuth() {
        sttService.requestAuthorization()
    }
    
    private func convertDomainModel(_ char: String) -> SttModel {
        return .init(word: char)
    }
}
