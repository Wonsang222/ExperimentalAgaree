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

protocol SttService {
    typealias Completion = (Result<String,SpeechError>) -> Void
    
    func request(
        on queue: DataTransferDispatchQueue,
        completion: @escaping Completion
    ) -> SttService?
    
    func appendRecogRequest(_ buffer: AudioBufferDTO) throws
    
    func stop()
}

typealias SpeechTaskUsable = SttService & AuthCheckable

final class DefaultSpeechService: SpeechTaskUsable {

    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest:SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer: SFSpeechRecognizer?
    
    private let config: SttConfigurable
    private let audioEngine: AudioEngineUsable

    init(
        audioEngine: AudioEngineUsable,
        config: SttConfigurable
        ) {
        self.audioEngine = audioEngine
        self.config = config
        }
    
    func request(
                on queue: any DataTransferDispatchQueue,
                completion: @escaping Completion
    ) -> SttService? {
    
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
        } catch {
            completion(.failure(.generateRecognizer))
        }
        return self
    }
    
    func appendRecogRequest(_ buffer: AudioBufferDTO) throws {
        let pcmBuffer = try convertToPCMBuffer(from: buffer)
        recognitionRequest?.append(pcmBuffer)
    }
    
    func stop() {
        self.recognitionTask?.cancel()
        self.recognitionRequest  = nil
        self.recognitionTask = nil
    }
    
    private func convertToPCMBuffer(from dto: AudioBufferDTO) throws -> AVAudioPCMBuffer {
        // AVAudioFormat을 생성합니다.
        guard let audioFormat = AVAudioFormat(standardFormatWithSampleRate: dto.format.sampleRate,
                                              channels: AVAudioChannelCount(dto.format.channelCount)) else {
            throw AudioError.generic
        }
        
        // AVAudioPCMBuffer를 생성합니다.
        guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(dto.data.count) / audioFormat.streamDescription.pointee.mBytesPerFrame) else {
            throw AudioError.generic
        }
        
        pcmBuffer.frameLength = pcmBuffer.frameCapacity

        // Data의 바이트를 pcmBuffer에 복사합니다.
        let audioBuffer = pcmBuffer.audioBufferList.pointee.mBuffers
        dto.data.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) in
            if let baseAddress = bufferPointer.baseAddress {
                memcpy(audioBuffer.mData, baseAddress, Int(audioBuffer.mDataByteSize))
            }
        }
        return pcmBuffer
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
            completion(true)
        @unknown default:
            completion(true)
        }
    }
}
