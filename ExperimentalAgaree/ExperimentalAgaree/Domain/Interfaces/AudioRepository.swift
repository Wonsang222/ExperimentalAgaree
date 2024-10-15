//
//  AudioRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/15/24.
//

import Foundation

protocol AudioRepository: AuthRepository {
    
    typealias Completion = (Result<AudioBufferDTO, Error>) -> Void
    
    func startRecognition(
        completion: @escaping Completion
    ) -> Cancellable?

}
