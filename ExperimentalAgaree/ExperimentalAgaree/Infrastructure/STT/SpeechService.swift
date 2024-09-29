//
//  SpeechTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/1/24.
//



import Foundation
import Speech

enum SpeechError: Error {
    case generateRecognizer
    case generateAudioEngine
    case system
}

extension SpeechError {
    var description: String {
        switch self {
        case .generateAudioEngine:
            return "오디오 엔진 에러입니다."
        default:
            return "오디오 엔진 에러입니다."
        }
    }
}

protocol SttConfigurable {
    var id: String { get }
}

struct SttConfiguration: SttConfigurable {
    let id: String
}

protocol SpeechTaskUsable {
    typealias Completion = (Result<String,SpeechError>) -> Void
    
    func request(
        on queue: DataTransferDispatchQueue,
        completion: @escaping Completion
    ) -> SpeechTaskUsable?
    
    func stop()
}

final class DefaultSpeechService: SpeechTaskUsable {

    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest:SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer: SFSpeechRecognizer?
    private var audioengine: AgareeAudio?
    
    let config: SttConfigurable
    let audioEngine: AudioEngineUsable

    init(
        audioEngine: AudioEngineUsable,
        config: SttConfigurable
        ) {
        self.audioEngine = audioEngine
        self.config = config
        }
    
    private func setRequest()  {
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest!.shouldReportPartialResults = true
    }
    
    private func generateRecognizer(config: SttConfigurable) throws {
        
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: config.id))
        
        if self.speechRecognizer == nil {
            throw SpeechError.generateRecognizer
        }
    }
    
    
#warning("코드 정리. -> Result 및 catch 연속 보기 안좋다")
    func request(
                on queue: any DataTransferDispatchQueue,
                completion: @escaping Completion
    ) -> SpeechTaskUsable? {
        
        do {
            setRequest()
            try generateRecognizer(config: config)
            
            guard let recognitionRequest = recognitionRequest else {
                completion(.failure(.system))
                return nil
            }
            
            self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest,
                                                                          resultHandler: { result, error in
                
                if result != nil {
                    let text = result?.bestTranscription.formattedString
                    guard let text = text else { return }
                    queue.asyncExecute {
                        completion(.success(text))
                    }
                }
            })
            
            self.audioengine = audioEngine.activateAudioEngine() { result in
                switch result {
                case .success(let buffer):
                    recognitionRequest.append(buffer)
                case .failure:
                    completion(.failure(.generateAudioEngine))
                }
            }
        } catch {
            completion(.failure(.generateRecognizer))
        }
        return self
    }
    
    func stop() {
        self.recognitionTask?.cancel()
        self.recognitionRequest  = nil
        self.recognitionTask = nil
        // bad code....
        (audioengine as? AVAudioEngine)?.agareeStop()
    }
}
