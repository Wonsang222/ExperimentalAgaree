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
    )
    func stop()
}

final class DefaultSpeechManager: SpeechTaskUsable {

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
    
    func request(
                on queue: any DataTransferDispatchQueue,
                completion: @escaping Completion
    ) {
        
        do {
            setRequest()
            try generateRecognizer(config: config)
            
            guard let recognitionRequest = recognitionRequest else { return }
            
            self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
                
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
    }
    
    func stop() {
        self.recognitionTask?.cancel()
        self.recognitionRequest  = nil
        self.recognitionTask = nil
        // bad code....
        (audioengine as? AVAudioEngine)?.agareeStop()
    }
}
