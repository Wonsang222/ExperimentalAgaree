//
//  DefaultSTTRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/15/24.
//

import Foundation

final class DefaultSTTRepository: STTRepository {

    private var sttService: SpeechTaskUsable
    private let executionQueue: DataTransferDispatchQueue
    
    init(sttService: SpeechTaskUsable,
         executionQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.sttService = sttService
        self.executionQueue = executionQueue
    }
    
    func startRecognition(buffer: AudioBufferDTO,completion: @escaping Completion) -> Cancellable?
    {
    
        do {
            try appendAudioBufferToSttRequest(buffer: buffer)
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
        } catch {
            completion(.failure(error))
            return nil
        }
    }
    
    private func appendAudioBufferToSttRequest(buffer: AudioBufferDTO) throws {
        try sttService.appendRecogRequest(buffer)
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
