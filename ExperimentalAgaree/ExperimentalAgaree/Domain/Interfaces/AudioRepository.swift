//
//  AudioRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/15/24.
//

import Foundation
import AVFoundation

typealias AudioRepository = AudioRecognizationRepository & AuthRepository

protocol AudioRecognizationRepository {
    
    typealias Completion = (Result< AVAudioPCMBuffer, Error>) -> Void
    
    func startRecognition(
        completion: @escaping Completion
    )
    
    func stop()

}
