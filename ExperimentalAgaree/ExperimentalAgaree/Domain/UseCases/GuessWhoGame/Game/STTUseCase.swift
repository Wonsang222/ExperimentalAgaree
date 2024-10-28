//
//  STTUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/15/24.
//

import Foundation

enum STTGameStatus {
    case Right
    case Clear
}

protocol STTUseCase {
    typealias Completion = (Result<GameJudge<STTGameStatus>, Error>) -> Void
    func startRecognition(target: GameModel?,
                          completion: @escaping Completion) -> Cancellable?
}

final class DefaultSTTUseCase: STTUseCase {
    
    private var sttStack: SttModel = SttModel(word: "")
    private let sttService: STTRepository
    private let audioService: AudioRepository

    init(sttService: STTRepository, audioService: AudioRepository) {
        self.sttService = sttService
        self.audioService = audioService
    }
    
    func startRecognition(target: GameModel?,
                          completion: @escaping Completion
    ) -> Cancellable? {
        
        var stt = SttTask()

        audioService.startRecognition { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let audioBufferDTO):
                stt = self.sttService.startRecognition(buffer: audioBufferDTO, completion: { sttResult in
                    switch sttResult {
                    case .success(let sttModel):
                        self.sttStack = self.sttStack + sttModel
                        let finalResult = self.judge(by: target)
                        completion(finalResult)
                    case .failure(let sttError):
                        completion(.failure(sttError))
                    }
                }) as! SttTask

            case .failure(let err):
                completion(.failure(err))
            }
        }
        return stt
    }

    private func judge(by target: GameModel?) -> Result<GameJudge<STTGameStatus>, Error> {
        // game clear
        guard let target = target,
              let targetName = target.name
        else {
            return .success(.data(.Clear))
        }
        // next model
        if sttStack.word.contains(targetName) {
            resetSttModel()
            return .success(.data(.Right))
        }
        return .success(.wrong)
    }

    private func resetSttModel() {
        sttStack = SttModel(word: "")
    }
}
