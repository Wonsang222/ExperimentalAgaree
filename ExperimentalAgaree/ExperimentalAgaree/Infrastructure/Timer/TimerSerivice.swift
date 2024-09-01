//
//  TimerSerivce.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/29/24.
//

import Foundation

protocol TimerManager {
    
    typealias TimerData = Float
    
    func startTimer(config: TimerConfigurable, handlerQueue: DispatchQueue, completion: @escaping (Float) -> Void) -> TimerUsable?
    
    func stopTimer()
}

final class DefaultTimerService: TimerManager {

    private var timer: TimerUsable?
    private let queue: DataTransferDispatchQueue
    
    init(
        queue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.queue = queue
    }
    
    func startTimer(
        config: TimerConfigurable,
        handlerQueue: DispatchQueue = DispatchQueue.main,
        completion: @escaping (Float) -> Void
    ) -> TimerUsable?
    {
        timer = nil
        let innerTimer = setTimer(config: config, handlerQueue: handlerQueue, completion: completion)
        timer = innerTimer
        queue.asyncExecute {
            RunLoop.current.add(innerTimer, forMode: .common)
            innerTimer.fire()
            RunLoop.current.run()
        }
        return timer
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setTimer(
        config: TimerConfigurable,
        handlerQueue: DispatchQueue,
        completion: @escaping (Float) -> Void
    ) -> Timer
    {
        let frequency = calculateGameSpeed(config: config)
        let timer = Timer(timeInterval: config.timeInterval, repeats: config.isRepeat) { _ in
            handlerQueue.async {
                completion(frequency)
            }
        }
        return timer
    }
    
    private func calculateGameSpeed(
        config: TimerConfigurable
    ) -> Float {
        let timerSpeed = (1.0 / config.gameTime) * 1.0
        return timerSpeed
    }
}
