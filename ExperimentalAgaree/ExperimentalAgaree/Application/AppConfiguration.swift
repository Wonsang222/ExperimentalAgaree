//
//  AppConfiguration.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/30/24.
//

import Foundation

final class AppConfiguration {
    
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiBundle") as? String else {
            fatalError()
        }
        return apiKey
    }()
    
    lazy var uuid: String = {
        guard let uuid = Bundle.main.object(forInfoDictionaryKey: "ApiUuid") as? String else {
            fatalError()
        }
        return uuid
    }()
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseUrl") as? String else {
            fatalError()
        }
        return apiBaseURL
    }()
    
    lazy var apiBasePhoto: String = {
        guard let apiBasePhoto = Bundle.main.object(forInfoDictionaryKey: "ApiPhotoBaseUrl") as? String else { fatalError() }
        return apiBasePhoto
    }()
}
