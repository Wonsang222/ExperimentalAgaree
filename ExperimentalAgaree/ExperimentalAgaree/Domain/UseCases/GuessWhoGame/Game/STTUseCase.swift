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
    func setAudioEngine(completion: @escaping (Result<Void, Error>) -> Void)
}

final class DefaultSTTUseCase: STTUseCase {
    
    private var _sttStack: SttModel = SttModel(word: "")
    private let _sttService: SttReqRepository
    private let _audioService: AudioRecognizationRepository

    
    init(
        sttService: SttReqRepository,
        audioService: AudioRecognizationRepository
    ) {
        self._sttService = sttService
        self._audioService = audioService
    }
    
    func setAudioEngine(completion: @escaping (Result<Void, Error>) -> Void) {
        _audioService.startRecognition { [weak self] result in
            switch result {
            case .success(let buffer):
                self?._sttService.appendAudioBufferToSttRequest(buffer: buffer)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func startRecognition(target: GameModelUsable,
                          completion: @escaping Completion
    ) -> Cancellable? {
        
       return _sttService.startRecognition() { result in
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
