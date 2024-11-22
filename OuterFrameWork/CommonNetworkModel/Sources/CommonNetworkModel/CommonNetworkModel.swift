//
//  File.swift
//  
//
//  Created by Wonsang Hwang on 11/22/24.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var baseHeaders: [String:String] { get }
    var queryParameter: [String:String] { get }
    var networkServiceType: NetworkServiceType { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
    
    let baseURL: URL
    let baseHeaders: [String : String]
    let queryParameter: [String : String]
    let networkServiceType: NetworkServiceType
    
    init(
        baseURL: URL,
        baseHeaders: [String : String] = [:],
        queryParameter: [String : String] = [:],
        networkServiceType: NetworkServiceType
    ) {
        self.baseURL = baseURL
        self.baseHeaders = baseHeaders
        self.queryParameter = queryParameter
        self.networkServiceType = networkServiceType
    }
}
