//
//  AudioEngineBuilderService.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/16/24.
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

protocol AudioSessionCofigurable {
    var category: AVAudioSession.Category { get }
    var mode: AVAudioSession.Mode { get }
    var bus: Int { get }
}

struct DefaultAudioSessionConfiguration: AudioSessionCofigurable {
   let category: AVAudioSession.Category
   let mode: AVAudioSession.Mode
   let bus: Int
}

protocol AudioEngineBuilder: AuthCheckable {
    func start(completion: @escaping (Result<AudioBufferDTO, AudioError>) -> Void)
    func stop()
}

final class AudioEngineBuilderService: AudioEngineBuilder {
    
    private let config: AudioSessionCofigurable
    private let engine = AVAudioEngine()
    
    init(config: AudioSessionCofigurable) {
        self.config = config
    }
    
    func start(completion: @escaping (Result<AudioBufferDTO, AudioError>) -> Void) {
        do {
            try setAudioSession()
            checkActivation(engine: engine)
            let inputNode = engine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: config.bus)
            inputNode.installTap(onBus: config.bus, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
                if let dto =  self?.convertDTO(buffer, format: recordingFormat) {
                    completion(.success(dto))
                }
            }
            engine.prepare()
            try engine.start()
        } catch {
            completion(.failure(resolveError(err: error)))
        }
    }

    func stop() {
        engine.stop()
        engine.inputNode.removeTap(onBus: config.bus)
    }
    
    
    private func checkActivation(engine: AVAudioEngine) {
         if engine.isRunning {
             stop()
         }
     }
    
    private func setAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(config.category)
        try session.setMode(config.mode)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    private func convertDTO(_ buffer: AVAudioPCMBuffer, format: AVAudioFormat) -> AudioBufferDTO {
        let audioData = buffer.audioBufferList.pointee.mBuffers.mData
        let dataSize = Int(buffer.audioBufferList.pointee.mBuffers.mDataByteSize)
        let data = Data(bytes: audioData!, count: dataSize)
        let format = AudioFormat(sampleRate: format.sampleRate, channelCount: Int(format.channelCount))
        let dto = AudioBufferDTO(data: data, format: format)
        return dto
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

extension AudioEngineBuilderService: AuthCheckable {
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
