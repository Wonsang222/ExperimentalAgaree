//
//  STTUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/15/24.
//

import Foundation

protocol STTUseCase: GameUseCase {
    typealias Completion = (Result<Void, Error>) -> Void
    func startRecognition(completion: @escaping Completion) -> Cancellable?
}

final class DefaultSTTUseCase: STTUseCase {
    
    private var sttStack: SttModel = SttModel(word: "")
    private let sttService: STTRepository
    
    private let rightBlock: (() -> Void)?
    private let wrongBlock: (() -> Void)?
    private let judgeBlock: (() -> Bool)?
    
    init(sttService: STTRepository,
         rightBlock: (() -> Void)? = nil,
         wrongBlock: (() -> Void)? = nil,
         judgeBlock: (() -> Bool)? = nil
    ) {
        self.sttService = sttService
        self.rightBlock = rightBlock
        self.wrongBlock = wrongBlock
        self.judgeBlock = judgeBlock
    }
    
    func startRecognition(completion: @escaping Completion) -> Cancellable? {
        sttService.startRecognition { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let sttModel):
                self.sttStack = self.sttStack + sttModel
                if self.judge() {
                    self.right()
                }
            case .failure(let sttError):
                completion(.failure(sttError))
            }
        }
    }
    
    func right() {
        resetSttModel()
        rightBlock?()
    }
    
    func wrong() {
        wrongBlock?()
    }
    
    func judge() -> Bool {
        guard let judgeBlock = judgeBlock else { return false }
        
        if judgeBlock() {
            return true
        }
        return false
    }
    
    private func resetSttModel() {
        sttStack = SttModel(word: "")
    }
}
