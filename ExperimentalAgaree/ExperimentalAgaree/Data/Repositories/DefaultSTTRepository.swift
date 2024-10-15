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
         executionQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.sttService = sttService
        self.executionQueue = executionQueue
    }
    
    func startRecognition(completion: @escaping Completion) -> Cancellable?
    {
        let sttTask = SttTask()
        sttTask.task = sttService?.request(on: executionQueue, completion: { result in
            switch result {
            case .success(let onOffModel):
                print(123)
            case .failure(let err):
                print(123)
            }
        })
        return sttTask
    }
    
    func checkAuth(completion: @escaping (Bool) -> Void) {
        sttService?.checkAuthorizatio(completion: completion)
    }
    
    func reqAuth() {
        sttService?.requestAuthorization()
    }
    
    private func convertDomainModel(_ char: String) -> SttModel {
        return .init(word: char)
    }
}
