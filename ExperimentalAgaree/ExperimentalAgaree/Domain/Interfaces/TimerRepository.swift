//
//  TimerRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/26/24.
//

import Foundation

protocol TimerRepository {
    func countGameTime(
        gameTime: Float,
        speed: Float,
        on queue: DispatchQueue,
        block: @escaping (_ totalSecond:  Float) -> Void 
    ) -> Timer?
}
