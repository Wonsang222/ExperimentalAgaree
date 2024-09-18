//
//  STTUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/15/24.
//

import Foundation

protocol STTUseCase: GameUseCase {
    func startRecognition(target: GameModel)
}

final class DefaultSTTUseCase: STTUseCase {
    
    private var sttStack: SttModel = SttModel(word: "")
    private let sttService: STTRepository
    
    private let rightCompletion: (() -> Void)?
    private let wrongCompletion: (() -> Void)?
    private let judgeCompletion: (() -> Bool)?
    
    init(sttService: STTRepository,
         rightCompletion: (() -> Void)?,
         wrongCompletion: (() -> Void)?,
         judgeCompletion: (() -> Bool)?
    ) {
        self.sttService = sttService
        self.rightCompletion = rightCompletion
        self.wrongCompletion = wrongCompletion
        self.judgeCompletion = judgeCompletion
    }
    
    func startRecognition(target: GameModel) {
        let task = sttService.startRecognition { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let sttModel):
                sttStack = sttStack + sttModel
                if judge() {
                    
                }
            case .failure(let sttError):
                print(123)
            }
        }
    }
    
    func right() {
        rightCompletion?()
    }
    
    func wrong() {
        wrongCompletion?()
    }
    
    func judge() -> Bool {
        guard let judgeCompletion = judgeCompletion else { return false }
        
        if judgeCompletion() {
            return true
        }
        
        return false
    }
    
    private func resetSttModel() {
        sttStack = SttModel(word: "")
    }
}
