//
//  AppConfiguration.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import Foundation

final class AppConfiguration {
    
    lazy var apiKey: String = {
//        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
//            fatalError()
//        }
        return "adsfasdf"
    }()
    
    lazy var uuid: String = {
//        guard let uuid = Bundle.main.object(forInfoDictionaryKey: "UUID") as? String else {
//            fatalError()
//        }
        return "adsfasdf"
    }()
    
    lazy var apiBaseURL: String = {
//        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
//            fatalError()
//        }
        return "fasd"
    }()
}
