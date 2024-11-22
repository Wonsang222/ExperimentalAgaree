//
//  File.swift
//  
//
//  Created by Wonsang Hwang on 11/22/24.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var baseHeaders: [String:String] { get }
    var queryParameter: [String:String] { get }
    var networkServiceType: NetworkServiceType { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
    
    public let baseURL: URL
    public let baseHeaders: [String : String]
    public let queryParameter: [String : String]
    public let networkServiceType: NetworkServiceType
    
    public init(
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
