//
//  DefaultSTTRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/15/24.
//

import Foundation

final class DefaultSTTRepository: STTRepository {
    
    private var sttService: SpeechTaskUsable?
    private let executionQueue: DataTransferDispatchQueue
    
    init(sttService: SpeechTaskUsable,
         executionQueue: DataTransferDispatchQueue
    ) {
        self.sttService = sttService
        self.executionQueue = executionQueue
    }
    
    func startRecognition(completion: @escaping Completion) -> Cancellable?
    {
        let sttTask = SttTask()
        sttTask.task = sttService?.request(on: executionQueue) { [weak self, executionQueue] result in
            guard let self = self else { return }
            switch result {
            case .success(let word):
                let domainModel = self.convertDomainModel(word)
                executionQueue.asyncExecute {
                    completion(.success(domainModel))
                }
            case .failure(let err):
                executionQueue.asyncExecute {
                    completion(.failure(err))
                }
            }
        }
        return sttTask
    }
    
    private func convertDomainModel(_ char: String) -> SttModel {
        return .init(word: char)
    }
}
