//
//  AsyncNetworkService.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 11/5/24.
//

import Foundation

protocol AsyncNetworkManager {
    func request(config: URLSessionConfiguration, request: URLRequest) async throws -> (Data, URLResponse)
}

final class DefaultAsyncNetworkManager: AsyncNetworkManager {
    func request(config: URLSessionConfiguration, request: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession(configuration: config).data(for: request)
    }
}



