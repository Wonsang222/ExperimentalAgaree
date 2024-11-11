//
//  AsyncNetworkService.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 11/5/24.
//

import Foundation

protocol AsyncSessionManager {
    func request(config: URLSessionConfiguration, request: URLRequest) async throws ->  Task<Data, Error>
}

final class DefaultAsyncSessionManager: AsyncSessionManager {
    
    func request(config: URLSessionConfiguration, request: URLRequest) async throws -> Task<Data, Error> {
        return Task {
            do {
                let (data, response) = try await URLSession(configuration: config).data(for: request)
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.error(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1, data: data)
                }
                return data
            } catch {
                throw resolveError(error: error)
            }
        }
    }
    
    private func resolveError(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .generic(error)
        }
    }
}

protocol AsyncNetworkService {
    func request(endpoint: Requestable) -> Task<Data, Error>
}

final class DefaultAsyncNetworkService: AsyncNetworkService {
    
    let config: NetworkConfigurable
    let session: AsyncSessionManager
    
    init(
        config: NetworkConfigurable,
        session: AsyncSessionManager = DefaultAsyncSessionManager()
    ) {
        self.config = config
        self.session = session
    }
    
    func request(endpoint: Requestable) -> Task<Data, Error> {
        Task {
            do {
                let req = try endpoint.urlRequest(with: config)
                let config = try endpoint.urlConfiguration(with: config)
                return try await session.request(config: config, request: req)
            } catch {
                
            }
        }
    }
}

