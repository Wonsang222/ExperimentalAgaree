//
//  STTRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import Foundation

protocol STTRepository {
    func recognize(
        on queue: DispatchQueue,
        completion: @escaping (SttModel) -> Void
    )
}
