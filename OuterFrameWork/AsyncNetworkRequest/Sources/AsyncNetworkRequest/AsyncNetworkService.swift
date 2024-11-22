//
//  File.swift
//  
//
//  Created by Wonsang Hwang on 11/22/24.
//

import Foundation

public final class AsyncNetworkService {
    private let _sessionManager: AsyncNetworkSessionManager
    private let _networkConfig: AsyncApiDataNetworkConfig
    
    public init(
        _sessionManager: AsyncNetworkSessionManager = AsyncNetworkSessionManager(),
        _networkConfig: AsyncApiDataNetworkConfig
    ) {
        self._sessionManager = _sessionManager
        self._networkConfig = _networkConfig
    }
    
    
    
}
