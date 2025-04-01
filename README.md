# ExperimentalAgaree 개인 프로젝트 정리
서버 해킹으로 인해 현재는 앱스토어 운영을 중지했습니다.
---

## 목표

- 아키텍쳐: MVVM - C (Kudoleh)의 코드를 분석하고 공부하면서 기존의 개인 프로젝트에 리팩토링했습니다.

- Swift Concurrency : 네트워크 통신을 Async/Await 을 사용해 작성하며 에러처리, 네트워크 레이어 구성을 고민했고, 이를 Module화를 했습니다.

- 테스트 : 각 레이어마다 의존성 주입(DI)를 사용하여 Testable한 코드를 작성했습니다.

- UIBeizierPath : UIBeizierPath로 ProgressBar를 만들어서 사용했습니다.

- Node Express 프레임 워크로 API 서버를 만들고, 이를 https://fly.io 에 배포하여, 앱스토어 서비스를 운영했습니다.

- 앱스토어 itms-apps://itunes.apple.com/app/id6450410415

---

# 앱의 구성
![Image](https://github.com/user-attachments/assets/0d7f43c4-17f7-4a4a-8d69-3a233f3278c6)

---

## STT

```swift
// STT는 Audio Engine과 함께 사용됨. Audio Engine setting
final class AudioEngineBuilderService: AudioEngineBuilder {
    
    private let _config: AudioSessionCofigurable
    private let _engine = AVAudioEngine()
    
    init(_config: AudioSessionCofigurable) {
        self._config = _config
    }
    
    func start(completion: @escaping (Result<AVAudioPCMBuffer, AudioError>) -> Void) {
        do {
            try setAudioSession()
            checkActivation(_engine: _engine)
            let inputNode = _engine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: _config.bus)
            inputNode.installTap(onBus: _config.bus, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                completion(.success(buffer))
            }
            _engine.prepare()
            try _engine.start()
        } catch {
            completion(.failure(resolveError(err: error)))
        }
    }

    func stop() {
        _engine.stop()
        _engine.inputNode.removeTap(onBus: _config.bus)
    }
    
    private func checkActivation(_engine: AVAudioEngine) {
         if _engine.isRunning {
             stop()
         }
     }
    
    private func setAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(_config.category)
        try session.setMode(_config.mode)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
    }
}
// STT -> Audio Engine에서 인식한 음성을 서버로 보내서, 문자열 타입의 리턴값을 받음
final class DefaultSpeechService: SpeechTaskUsable {
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private let recognizer: SFSpeechRecognizer
    private let config: SttConfigurable

    init(
        config: SttConfigurable
        ) {
        self.config = config
        self.recognitionRequest.shouldReportPartialResults = true
        self.recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: config.id))!
        }
    
    func request(
                on queue: any DataTransferDispatchQueue,
                completion: @escaping Completion
    ) -> SttTaskCancellable? {
    
            let task = recognizer.recognitionTask(with: recognitionRequest,
                                                                          resultHandler: { result, error in
                
                if result != nil {
                    let text = result?.bestTranscription.formattedString
                    guard let text = text else { return }
                    queue.asyncExecute {
                        completion(.success(text))
                    }
                }
            })
            return task
    }
    
    func appendRecogRequest(_ buffer:  AVAudioPCMBuffer) {
        recognitionRequest.append(buffer)
    }
}
// 위 두개의 서비스들은 아래 Usecase에서 사용
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
                completion(.success(finalResult))
            case .failure(let sttError):
                completion(.failure(sttError))
            }
        }
    }

    func stopRecognitioin() {
        _audioService.stop()
    }

    private func judge(by target: GameModelUsable) -> GameJudge<STTGameStatus> {
        
        if target is GameClearModel {
            return .data(.Clear)
        } else if _sttStack.word.contains(target.name) {
            resetSttModel()
            return .data(.Right)
        }
        return .wrong
    }

    private func resetSttModel() {
        _sttStack = SttModel(word: "")
    }
}
```



 
