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
        audioService.startRecognition { [weak self] result in
            switch result {
            case .success(let audioBufferDTO):
                let task = sttService.startRecognition(buffer: audioBufferDTO) { result in
                    
                }
                
            case .failure(let audioErr):
                print(123)
            }
        }

        
        
//        sttService.startRecognition { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let sttModel):
//                self.sttStack = self.sttStack + sttModel
//                let result = judge(by: target)
//                completion(result)
//            case .failure(let sttError):
//                completion(.failure(sttError))
//            }
//        }
        return nil
    }
    
    private func startAudioEngine(completion: @escaping () -> Void) {
        audioService.startRecognition { result in
            switch result {
            case .success(let audioBufferDTO):
                print(123)
            case .failure(let audioErr):
                print(123)
            }
        }
    }
    
    private func judge(by target: GameModel?) -> Result<GameJudge<STTGameStatus>, Error> {
        // game clear
        guard let target = target else {
            return .success(.data(.Clear))
        }
        // next model
        if sttStack.word.contains(target.name) {
            resetSttModel()
            return .success(.data(.Right))
        }
        return .success(.wrong)
    }

    private func resetSttModel() {
        sttStack = SttModel(word: "")
    }
}
