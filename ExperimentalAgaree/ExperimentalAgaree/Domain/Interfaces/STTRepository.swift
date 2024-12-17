//
//  STTRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import Foundation
import AVFoundation

typealias STTRepository = SttReqRepository & AuthRepository

protocol AuthRepository {
    func checkAuth(completion: @escaping (Bool) -> Void)
    func reqAuth()
    var description: String { get }
}

protocol SttReqRepository {
    
    typealias Completion = (Result<SttModel, Error>) -> Void
    
    func startRecognition(buffer:  AVAudioPCMBuffer,completion: @escaping Completion) -> Cancellable?
}
