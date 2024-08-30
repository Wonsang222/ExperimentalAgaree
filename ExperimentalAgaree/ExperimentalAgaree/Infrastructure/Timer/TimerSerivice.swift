//
//  TimerSerivce.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/29/24.
//

import Foundation

// 에러 추가하기 기존에 timer가 있을때, 다시 만드는건 에러

protocol TimerManager {
    func startTimer
    (config: TimerConfigurable,
     block: @escaping () -> Void,
     completion: @escaping (_ sec: Float) -> Void
    ) -> TimerUsable?
}

final class DefaultTimerService: TimerManager {

    private var timer: TimerUsable?
    private let queue: DataTransferDispatchQueue
    
    init(queue: DataTransferDispatchQueue) {
        self.queue = queue
    }
    
    func startTimer(
        config: TimerConfigurable,
        block: @escaping () -> Void,
        completion: @escaping (Float) -> Void
    ) -> TimerUsable? {
        
    }
    
    private func calculateGameSpeed(
        config: TimerConfigurable
    ) -> Float {
            
    }
}
