//
//  STTRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import Foundation

protocol STTRepository {
    func startRecognition(
        completion: @escaping (SttModel) -> Void
    )
    
    func stop()
}
