//
//  File.swift
//  
//
//  Created by Wonsang Hwang on 11/22/24.
//

import Foundation
import CommonNetworkModel


#warning("dependency 설정해야함")
public final class AsyncNetworkService {
    private let _sessionManager: AsyncNetworkSessionManager
    private let _networkConfig: NetworkConfigurable
    
    public init(
        _sessionManager: AsyncNetworkSessionManager = AsyncNetworkSessionManager(),
        _networkConfig: NetworkConfigurable
    ) {
        self._sessionManager = _sessionManager
        self._networkConfig = _networkConfig
    }
}
