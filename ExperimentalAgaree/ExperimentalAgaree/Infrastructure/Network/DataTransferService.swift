//
//  DataTransferService.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/22/24.
//

import Foundation

enum DatatransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

extension DatatransferError {
    var description: String {
        return "데이터 에러입니다."
    }
}

protocol DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void)
}

extension DispatchQueue: DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void) {
        async(execute: work)
    }
}

protocol DataTransferService {
    typealias Completion<T> = (Result<T, DatatransferError>) -> Void
    
    func request<T: Decodable, F: ResponseRequestable> (
        with endpoint: F,
        on queue: DataTransferDispatchQueue,
        completion: @escaping Completion<T>
    ) -> NetworkCancellable? where T == F.Response
    
    func request<F: ResponseRequestable> (
        with endpoint: F,
        on queue: DataTransferDispatchQueue,
        completion: @escaping Completion<Void>
    ) -> NetworkCancellable? where F.Response == Void
}

final class DefaultDataTransferService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func decode<T:Decodable>(
        data: Data?,
        decoder: ResponseDecoder
    ) -> Result<T, DatatransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<T, F>
    (with endpoint: F,
     on queue: DataTransferDispatchQueue,
     completion: @escaping Completion<T>
    ) -> NetworkCancellable? where T : Decodable, T == F.Response, F : ResponseRequestable {
        let task = networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DatatransferError> = self.decode(data: data,
                                                                       decoder: endpoint.responseDecoder)
                queue.asyncExecute {
                    completion(result)
                }
            case .failure(let netErr):
                queue.asyncExecute {
                    completion(.failure(.networkFailure(netErr)))
                }
            }
        }
        return task
    }
    
    func request<F>(
        with endpoint: F,
        on queue: DataTransferDispatchQueue,
        completion: @escaping Completion<Void>
    ) -> NetworkCancellable? where F : ResponseRequestable, F.Response == () {
        let task = networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                queue.asyncExecute {
                    completion(.success(()))
                }
            case .failure(let netErr):
                queue.asyncExecute {
                    completion(.failure(.networkFailure(netErr)))
                }
            }
        }
        return task
    }
}

final class DefaultJsonResponseDecoder: ResponseDecoder {
    let decoder = JSONDecoder()
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try decoder.decode(T.self, from: data)
    }
}
