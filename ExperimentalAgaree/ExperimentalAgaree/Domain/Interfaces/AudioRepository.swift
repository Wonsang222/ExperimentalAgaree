//
//  AudioRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/15/24.
//

import Foundation

typealias AudioRepository = AudioRecognizationRepository & AuthRepository

protocol AudioRecognizationRepository {
    
    typealias Completion = (Result<AudioBufferDTO, Error>) -> Void
    
    func startRecognition(
        completion: @escaping Completion
    )
    
    func stop()

}
