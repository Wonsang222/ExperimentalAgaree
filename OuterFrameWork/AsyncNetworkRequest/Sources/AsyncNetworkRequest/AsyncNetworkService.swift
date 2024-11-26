//
//  File.swift
//  
//
//  Created by Wonsang Hwang on 11/22/24.
//

import Foundation
import CommonNetworkModel

public protocol AsyncNetworkService {
    func request(endpoint: Requestable) async throws -> Data
}

public final class DefaultAsyncNetworkService {
    private let _sessionManager: AsyncSessionManager
    private let _networkConfig: NetworkConfigurable
    
    public init(
        _sessionManager: AsyncNetworkSessionManager = AsyncNetworkSessionManager(),
        _networkConfig: NetworkConfigurable
    ) {
        self._sessionManager = _sessionManager
        self._networkConfig = _networkConfig
    }
    
    private func resolve(error: Error) -> NetworkError {
        let errCode = URLError.Code(rawValue: (error as NSError).code)
        switch errCode {
        case .cancelled: return .cancelled
        case .notConnectedToInternet: return .notConnected
        default: return .generic(error)
        }
    }
    
    private func resolve(response: URLResponse) throws {
        guard let resp = response as? HTTPURLResponse else {
            throw NetworkError.notConnected
        }
        
        if !(200...299).contains(resp.statusCode) {
            throw NetworkError.notConnected
        }
    }
    
    private func generateURL(endpoint: Requestable,
                             config: NetworkConfigurable
    ) throws -> URLRequest {
        do {
            return try endpoint.urlRequest(with: config)
        } catch {
            throw NetworkError.urlGeneration
        }
    }
    
    private func makeRequest(request: URLRequest,
                             config: URLSessionConfiguration
    ) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await _sessionManager.request(req: request, config: config)
            return (data, response)
        } catch {
            throw resolve(error: error)
        }
    }
}

extension DefaultAsyncNetworkService: AsyncNetworkService {
    public func request(endpoint: Requestable) async throws -> Data {
        let request = try generateURL(endpoint: endpoint, config: _networkConfig)
        let (data, response) = try await makeRequest(request: request, config: endpoint.urlConfiguration(with: _networkConfig))
        try resolve(response: response)
        return data
    }
}
