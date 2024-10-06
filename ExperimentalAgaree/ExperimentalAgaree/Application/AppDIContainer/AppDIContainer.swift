//
//  AppDIContainer.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import Foundation

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          baseHeaders: ["Authorization":appConfiguration.uuid,
                                                        "User-Agent": appConfiguration.apiKey],
                                          networkServiceType: .responsive)
        
        let apiDataService = DefaultNetworkService(config: config)
        return DefaultDataTransferService(networkService: apiDataService)
    }()
    
    lazy var timerService: TimerManager =  {
        let config = DefaultTimerConfiguration(timeInterval: 0.2, isRepeat: false)
        return DefaultTimerService(config: config)
    }()
    
    lazy var sttService: SpeechTaskUsable = {
        let audioConfig = DefaultAudioSessionConfiguration(category: .record, mode: .measurement)
        let audioService = AudioEngineManager(audioSessionConfig: audioConfig)
        let sttConfig = SttConfiguration(id: "ko-KR")
        let sttservice = DefaultSpeechService(audioEngine: audioService, config: sttConfig)
        return sttservice
    }()
    
    func makeGameSceneDIContainer() -> GameSceneDIContainer {
        let dependencies = GameSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            sttService: sttService,
            timerService: timerService)
        return GameSceneDIContainer(dependencies: dependencies)
    }
}
