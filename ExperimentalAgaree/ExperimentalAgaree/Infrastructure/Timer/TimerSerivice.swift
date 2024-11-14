//
//  TimerSerivce.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/29/24.
//

import Foundation

protocol TimerManager {
    func startTimer(
        gameSec:Float,
        handlerQueue: DispatchQueue,
        completion: @escaping (Float) -> Void
    ) -> TimerUsable?
}

final class DefaultTimerService: TimerManager {

    private let _queue: DataTransferDispatchQueue
    private let _config: TimerConfigurable
    
    init(
        queue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInteractive),
        config: TimerConfigurable
    ) {
        self._queue = queue
        self._config = config
    }
    
    @discardableResult
    func startTimer(
        gameSec:Float,
        handlerQueue: DispatchQueue,
        completion: @escaping (Float) -> Void
    ) -> TimerUsable?
    {
        let timer = setTimer(gameTime: gameSec,
                                  config: _config,
                                  handlerQueue: handlerQueue,
                                  completion: completion)
        _queue.asyncExecute {
            RunLoop.current.add(timer, forMode: .common)
            timer.fire()
            RunLoop.current.run()
        }
        return timer
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
