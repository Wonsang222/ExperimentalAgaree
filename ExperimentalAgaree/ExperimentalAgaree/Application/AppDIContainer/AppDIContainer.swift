//
//  AppDIContainer.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import Foundation
import CommonNetworkModel
import AsyncNetworkRequest

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
    
    lazy var asyncDataTransferService: AsyncDataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: " ")!,
                                          baseHeaders: ["Authorization":appConfiguration.uuid,
                                                        "User-Agent": appConfiguration.apiKey],
                                          networkServiceType: .responsive)
        let asyncNetworkService = DefaultAsyncNetworkService(_networkConfig: config)
        return DefaultAsyncDataTransferService(_asyncNetworkService: asyncNetworkService)
    }()
    
    lazy var asyncGroupDataTransferService: AsyncGroupDatatransferService = {
       return DefaultAsyncGroupDatatransferService(_asyncDatatransferService: asyncDataTransferService)
    }()
    
    lazy var timerService: TimerManager =  {
        let config = DefaultTimerConfiguration(timeInterval: 0.2, isRepeat: false)
        return DefaultTimerService(config: config)
    }()
    
    lazy var audioService: AudioEngineBuilder = {
        let config:AudioSessionCofigurable = DefaultAudioSessionConfiguration(category: .record, mode: .measurement, bus: 0)
        let service = AudioEngineBuilderService(_config: config)
        return service
    }()
    
    lazy var sttService: SpeechTaskUsable = {
        let config: SttConfigurable = SttConfiguration(id: "ko")
        let service = DefaultSpeechService(config: config)
        return service
    }()
    
    func makeGameSceneDIContainer() -> GameSceneDIContainer {
        let dependencies = GameSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            sttService: sttService,
            timerService: timerService,
            audioService: audioService)
        return GameSceneDIContainer(dependencies: dependencies)
    }
}
