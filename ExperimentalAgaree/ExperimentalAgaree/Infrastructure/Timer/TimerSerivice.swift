//
//  TimerSerivce.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/29/24.
//

import Foundation

protocol TimerManager {
    @discardableResult
    func startTimer(
        gameSec:Float,
        handlerQueue: DispatchQueue,
        completion: @escaping (Float) -> Void
    ) -> TimerUsable?
    func stopTimer()
}

final class DefaultTimerService: TimerManager {

    private var timer: TimerUsable?
    private let queue: DataTransferDispatchQueue
    private let config: TimerConfigurable
    
    init(
        queue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated),
        config: TimerConfigurable
    ) {
        self.queue = queue
        self.config = config
    }
    
    @discardableResult
    func startTimer(
        gameSec:Float,
        handlerQueue: DispatchQueue,
        completion: @escaping (Float) -> Void
    ) -> TimerUsable?
    {
        timer = nil
        let innerTimer = setTimer(gameTime: gameSec, config: config, handlerQueue: handlerQueue, completion: completion)
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
        gameTime: Float,
        config: TimerConfigurable,
        handlerQueue: DispatchQueue,
        completion: @escaping (Float) -> Void
    ) -> Timer
    {
        let frequency = calculateGameSpeed(gameSecond: gameTime)
        let timer = Timer(timeInterval: config.timeInterval,
                          repeats: config.isRepeat) { _ in
            handlerQueue.async {
                completion(frequency)
            }
        }
        return timer
    }
    
    private func calculateGameSpeed(
        gameSecond:Float
    ) -> Float {
        let timerSpeed = (1.0 / gameSecond) * 1.0
        return timerSpeed
    }
}
