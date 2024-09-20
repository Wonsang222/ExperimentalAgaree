//
//  STTUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/15/24.
//

import Foundation

protocol STTUseCase {
    typealias Completion = (Result<Void, Error>) -> Void
    func startRecognition(target: GameModel ,completion: @escaping Completion) -> Cancellable?
}

final class DefaultSTTUseCase: STTUseCase {
    
    private var sttStack: SttModel = SttModel(word: "")
    private let sttService: STTRepository

    init(sttService: STTRepository
    ) {
        self.sttService = sttService
    }
    
    func startRecognition(target: GameModel,
                          completion: @escaping Completion
    ) -> Cancellable? {
        sttService.startRecognition { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let sttModel):
                // target과 stt 일치할때
                self.sttStack = self.sttStack + sttModel
                if self.judge(by: target) {
                    self.resetSttModel()
                    completion(.success(()))
                }
            case .failure(let sttError):
                completion(.failure(sttError))
            }
        }
    }

    private func judge(by target: GameModel) -> Bool {
        if sttStack.word.contains(target.name) {
            return true
        }
        return false
    }
    
    private func resetSttModel() {
        sttStack = SttModel(word: "")
    }
}
