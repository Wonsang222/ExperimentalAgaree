//
//  Network.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/21/24.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

extension NetworkError {
    var description: String {
        switch self {
        case .urlGeneration:
            return "잘못된 url 입니다."
        default:
            return "네트워크 에러입니다."
        }
    }
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


final class DefaultNetworkService: NetworkService {
    
    let config: NetworkConfigurable
    let session: NetworkSessionManager
    
    init(
        config: NetworkConfigurable,
        session: NetworkSessionManager = DefaultNetworkSessionManager()
    ) {
        self.config = config
        self.session = session
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
    
    private func makeRequest(
        request: URLRequest,
        configuration: URLSessionConfiguration,
        completion: @escaping Completion
    ) -> NetworkCancellable {
        let task = session.request(req: request, config: configuration) { data, resp, err in
            if let err = err {
                var netError: NetworkError
                if let resp = resp as? HTTPURLResponse {
                    netError = NetworkError.error(statusCode: resp.statusCode, data: data)
                } else {
                    netError  = self.resolveError(error: err)
                }
                completion(.failure(netError))
            } else {
                completion(.success(data))
            }
        }
        return task
    }
    
    func request(
        endpoint: Requestable,
        completion: @escaping Completion
    ) -> NetworkCancellable? {
        do {
            let req = try endpoint.urlRequest(with: config)
            let configuration = endpoint.urlConfiguration(with: config)
            let task = self.makeRequest(request: req, configuration: configuration, completion: completion)
            return task
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}
