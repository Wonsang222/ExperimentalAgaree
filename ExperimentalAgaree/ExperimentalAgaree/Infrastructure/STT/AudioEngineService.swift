//
//  AudioEngineService.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/31/24.
//

import Foundation
import AVFoundation

protocol AgareeAudio {
    func start() throws
}

// 수정
extension AgareeAudio where Self: AVAudioEngine {
    func agareeStop() {
        self.stop()
        self.inputNode.removeTap(onBus: 0)
    }
}

enum AudioError: Error {
    case systemError
    case sessionError
    case generic
}

extension AVAudioEngine: AgareeAudio {}

protocol AudioEngineUsable {
    func activateAudioEngine(completion: @escaping (Result<AVAudioPCMBuffer, AudioError>) -> Void) -> AgareeAudio?
    func stop(engine: AVAudioEngine)
}

protocol AudioSessionCofigurable {
    var category: AVAudioSession.Category { get }
    var mode: AVAudioSession.Mode { get }
}

struct DefaultAudioSessionConfiguration: AudioSessionCofigurable {
    var category: AVAudioSession.Category
    var mode: AVAudioSession.Mode
}

final class AudioEngineManager: AudioEngineUsable {
    
    private let audioSessionConfig: AudioSessionCofigurable
    
    init(audioSessionConfig: AudioSessionCofigurable) {
        self.audioSessionConfig = audioSessionConfig
    }

    func activateAudioEngine(
                 completion: @escaping (Result<AVAudioPCMBuffer, AudioError>) -> Void
    ) -> AgareeAudio? {
        do {
            try setAudioSession()
            let engine = AVAudioEngine()
            checkActivation(engine: engine)
            let inputNode = engine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                completion(.success(buffer))
            }
            engine.prepare()
            try engine.start()
            
            return engine
        } catch {
            let resolvedError = resolveError(err: error)
            completion(.failure(resolvedError))
            return nil
        }
    }
    
    func stop(engine: AVAudioEngine) {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
    }
    
   private func checkActivation(engine: AVAudioEngine) {
        if engine.isRunning {
            stop(engine: engine)
        }
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

extension AudioEngineManager: AuthCheckable {
    
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


