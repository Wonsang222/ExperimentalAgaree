//
//  TimerSerivce.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/29/24.
//

import Foundation

enum TimerError: Error {
    case isExisted
    case generateTimer
}

protocol TimerManager {
    
    typealias TimerData = Float
    
    func startTimer
    (config: TimerConfigurable,
     handlerQueue: DispatchQueue,
     completion: @escaping (Result<TimerData,TimerError>) -> Void
    ) -> TimerUsable?
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
        completion: @escaping (Result<TimerData,TimerError>) -> Void
    ) -> TimerUsable? {
        
        var innerTimer: Timer? = nil
        
        guard timer != nil else {
            completion(.failure(.isExisted))
            return nil
        }
        
       let frequency = calculateGameSpeed(config: config)
        queue.asyncExecute { [weak self] in
            guard let self = self else { return }
            
            innerTimer = Timer(timeInterval: config.timeInterval,
                               repeats: config.isRepeat,
                               block: { _ in
                handlerQueue.async {
                    completion(.success(frequency))
                }
            })
            
            guard let innerTimer = innerTimer else {
                completion(.failure(.generateTimer))
                return
            }
            
            RunLoop.current.add(innerTimer, forMode: .common)
            innerTimer.fire()
            RunLoop.current.run()
        }
        return innerTimer
    }
    
    private func calculateGameSpeed(
        config: TimerConfigurable
    ) -> Float {
        let timerSpeed = (1.0 / config.gameTime) * 1.0
        return timerSpeed
    }
}
