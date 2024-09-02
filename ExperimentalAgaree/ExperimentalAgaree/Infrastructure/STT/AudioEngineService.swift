//
//  AudioEngineService.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/31/24.
//

import Foundation
import AVFoundation



/// audio engine
/// 1. inputNode install ^ completion
/// 2. inputNode output format
/// 3. stop + remove tap
///
/// 4.  prepare()
/// 5. start() ^ throws
///


protocol AgareeAudio {
    func start() throws
}

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
    
    let audioSessionConfig: AudioSessionCofigurable
    
    init(audioSessionConfig: AudioSessionCofigurable) {
        self.audioSessionConfig = audioSessionConfig
    }

    func activateAudioEngine(
                 completion: @escaping (Result<AVAudioPCMBuffer, AudioError>) -> Void
    ) -> AgareeAudio? {
        do {
            let engine = AVAudioEngine()
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


