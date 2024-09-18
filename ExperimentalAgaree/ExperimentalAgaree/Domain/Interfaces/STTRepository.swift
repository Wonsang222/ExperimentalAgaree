//
//  STTRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import Foundation

protocol STTRepository {
    
    typealias Completion = (Result<SttModel, Error>) -> Void
    
    func startRecognition(
        completion: @escaping Completion
    ) -> Cancellable?
}
