//
//  AudioEngineBuilderService.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/16/24.
//

import Foundation
import AVFoundation

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
    func start(completion: @escaping (Result<AVAudioPCMBuffer, AudioError>) -> Void)
    func stop()
}

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
