//
//  File.swift
//  
//
//  Created by Wonsang Hwang on 11/22/24.
//

import Foundation

public struct AsyncApiDataNetworkConfig {
    
    let baseURL: URL
    let baseHeaders: [String : String]
    let queryParameter: [String : String]
    
    init(
        baseURL: URL,
        baseHeaders: [String : String] = [:],
        queryParameter: [String : String] = [:]
    ) {
        self.baseURL = baseURL
        self.baseHeaders = baseHeaders
        self.queryParameter = queryParameter
    }
}
