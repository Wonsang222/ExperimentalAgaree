//
//  Network.swift
//  ExperimentalAgaree
//
//  Created by 위사모바일 on 8/21/24.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable {}

protocol NetworkSessionManager {
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    
    func request(req: URLRequest, config: URLSessionConfiguration, completion: @escaping Completion) -> NetworkCancellable
}

protocol NetworkService {
    typealias Completion = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping Completion) -> NetworkCancellable?
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(
        req: URLRequest,
        config: URLSessionConfiguration,
        completion: @escaping Completion
    ) -> NetworkCancellable {
        let task = URLSession(configuration: config).dataTask(with: req, completionHandler: completion)
        task.resume()
        return task
    }
}
