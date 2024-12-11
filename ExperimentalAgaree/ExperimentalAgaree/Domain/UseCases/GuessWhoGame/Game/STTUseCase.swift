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
    func startRecognition(target: GameModelUsable,
                          completion: @escaping Completion) -> Cancellable?
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
    
    #warning("????")
    func startRecognition(target: GameModelUsable,
                          completion: @escaping Completion
    ) -> Cancellable? {
        
        var stt = SttTask()

        _audioService.startRecognition { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let audioBufferDTO):
                stt = self._sttService.startRecognition(buffer: audioBufferDTO, completion: { sttResult in
                    switch sttResult {
                    case .success(let sttModel):
                        self._sttStack = self._sttStack + sttModel
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
