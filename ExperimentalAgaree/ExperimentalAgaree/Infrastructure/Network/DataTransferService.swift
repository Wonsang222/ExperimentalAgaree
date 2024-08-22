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

protocol DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void)
}

// 수정해야할수도있음. group
#warning("Might 수정")
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

