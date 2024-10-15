//
//  AudioEngineService.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/31/24.
//

import Foundation
import AVFoundation

struct AudioBufferDTO {
    let data: Data
    let format: AudioFormat
}

struct AudioFormat {
    let sampleRate: Double
    let channelCount: Int
}

enum AudioError: Error {
    case systemError
    case sessionError
    case generic
}

protocol AudioEngineUsable {
    func activateAudioEngine(completion: @escaping (Result<AudioBufferDTO, AudioError>) -> Void) -> AudioEngineUsable?
    func stop()
}

protocol AudioSessionCofigurable {
    var category: AVAudioSession.Category { get }
    var mode: AVAudioSession.Mode { get }
}

struct DefaultAudioSessionConfiguration: AudioSessionCofigurable {
    var category: AVAudioSession.Category
    var mode: AVAudioSession.Mode
}

typealias AudioEngineService = AudioEngineUsable & AuthCheckable

final class AudioEngineManager: AudioEngineService {
    
    private let audioSessionConfig: AudioSessionCofigurable
    private var engine: AVAudioEngine!
    
    init(audioSessionConfig: AudioSessionCofigurable) {
        self.audioSessionConfig = audioSessionConfig
    }

    func activateAudioEngine(
                 completion: @escaping (Result<AudioBufferDTO, AudioError>) -> Void
    ) -> AudioEngineUsable? {
        do {
            try setAudioSession()
            engine = AVAudioEngine()
            checkActivation(engine: engine)
            let inputNode = engine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
                if let dto = try? self?.convertDTO(buffer, format: recordingFormat) {
                    completion(.success(dto))
                }
            }
            engine.prepare()
            try engine.start()
            
            return self
        } catch {
            let resolvedError = resolveError(err: error)
            completion(.failure(resolvedError))
            return nil
        }
    }
    func stop() {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
    }
    
   private func checkActivation(engine: AVAudioEngine) {
        if engine.isRunning {
            stop()
        }
    }
    
    private func convertDTO(_ buffer: AVAudioPCMBuffer, format: AVAudioFormat) throws -> AudioBufferDTO {
        let audioData = buffer.audioBufferList.pointee.mBuffers.mData
        let dataSize = Int(buffer.audioBufferList.pointee.mBuffers.mDataByteSize)
        let data = Data(bytes: audioData!, count: dataSize)
        let format = AudioFormat(sampleRate: format.sampleRate, channelCount: Int(format.channelCount))
        let dto = AudioBufferDTO(data: data, format: format)
        return dto
    }
    
    // Result로 만들 수 있다
    private func setAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(audioSessionConfig.category)
        try session.setMode(audioSessionConfig.mode)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
}
    
    private func resolveError(err: Error) -> AudioError {
        let code = AVAudioSession.ErrorCode(rawValue: (err as NSError).code)
        
        switch code {
        case .cannotInterruptOthers, .expiredSession, .isBusy:
            return .systemError
        default:
            return .generic
        }
    }
}

extension AudioEngineManager {
    
    func getDescription() -> String {
        return "마이크"
    }
    
    func requestAuthorization() {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
        }
    }
 
    func checkAuthorizatio(completion: @escaping (Bool) -> Void) {
        let micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch micStatus{
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}


