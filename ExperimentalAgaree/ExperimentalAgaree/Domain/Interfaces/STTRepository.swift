//
//  STTRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import Foundation

protocol AuthRepository {
    func checkAuth(completion: @escaping (Bool) -> Void)
    func reqAuth()
}

protocol STTRepository: AuthRepository {
    
    typealias Completion = (Result<SttModel, Error>) -> Void
    
    func startRecognition(buffer: AudioBufferDTO,completion: @escaping Completion) -> Cancellable?
}
