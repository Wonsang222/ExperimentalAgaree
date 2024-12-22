//
//  STTUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/15/24.
//

import Foundation
import AVFoundation

enum STTGameStatus {
    case Right
    case Clear
}

protocol STTUseCase {
    typealias Completion = (Result<GameJudge<STTGameStatus>, Error>) -> Void
    func startRecognition(target: GameModelUsable,
                          completion: @escaping Completion) -> Cancellable?
    func stopRecognitioin()
}

final class DefaultSTTUseCase: STTUseCase {
    
    private var _sttStack: SttModel = SttModel(word: "")
    private let _sttService: SttReqRepository
    private let _audioService: AudioRecognizationRepository
    private var buffer: AVAudioPCMBuffer?
    
    init(
        sttService: SttReqRepository,
        audioService: AudioRecognizationRepository
    ) {
        self._sttService = sttService
        self._audioService = audioService
    }
    
    private func teamp() {
        _audioService.startRecognition { [weak self] result in
            switch result {
            case .success(let buffer):
                self?.buffer = buffer
            case .failure(let error):
                print(123)
            }
        }
    }

    func startRecognition(target: GameModelUsable,
                          completion: @escaping Completion
    ) -> Cancellable? {
        
        _sttService.startRecognition(buffer: <#T##AVAudioPCMBuffer#>) { result in
            switch result {
            case .success(let sttModel):
                self._sttStack = self._sttStack + sttModel
                let finalResult = self.judge(by: target)
                completion(finalResult)
            case .failure(let sttError):
                completion(.failure(sttError))
            }
        }
    }
        
//        _audioService.startRecognition { [weak self] result in
//        guard let self = self else { return }
//            
//            switch result {
//            case .success(let audioBufferDTO):
//                return self._sttService.startRecognition(buffer: audioBufferDTO, completion: { sttResult in
//                    switch sttResult {
//                    case .success(let sttModel):
//                        self._sttStack = self._sttStack + sttModel
//                        let finalResult = self.judge(by: target)
//                        completion(finalResult)
//                    case .failure(let sttError):
//                        completion(.failure(sttError))
//                        return nil
//                    }
//                })
//                
//            case .failure(let err):
//                completion(.failure(err))
//            }
//        }

#warning("no usage")
    func stopRecognitioin() {
        _audioService.stop()
    }

    private func judge(by target: GameModelUsable) -> Result<GameJudge<STTGameStatus>, Error> {
        // next model
        if _sttStack.word.contains(target.name) {
            resetSttModel()
            return .success(.data(.Right))
        }
        return .success(.wrong)
    }

    private func resetSttModel() {
        _sttStack = SttModel(word: "")
    }
}
