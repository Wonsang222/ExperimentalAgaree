//
//  SpeechTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/1/24.
//

import Foundation
import AVFoundation
import Speech


protocol SttTaskCancellable {
    func cancel()
}

extension SFSpeechRecognitionTask: SttTaskCancellable {}

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
            return "오디오 엔진(Generic) 에러입니다."
        }
    }
}

protocol SttConfigurable {
    var id: String { get }
}

struct SttConfiguration: SttConfigurable {
    let id: String
}

protocol SttService {
    typealias Completion = (Result<String,SpeechError>) -> Void
    
    func request(
                on queue: any DataTransferDispatchQueue,
                completion: @escaping Completion
    ) -> SttTaskCancellable?
    
    func appendRecogRequest(_ buffer:  AVAudioPCMBuffer)
}

typealias SpeechTaskUsable = SttService & AuthCheckable

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

extension DefaultSpeechService {
    
    func getDescription() -> String {
        return "음성인식"
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                break
            default:
                break
            }
        }
    }
    
    func checkAuthorizatio(completion: @escaping (Bool) -> Void) {
        let speechStatus = SFSpeechRecognizer.authorizationStatus()
        switch speechStatus{
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}
