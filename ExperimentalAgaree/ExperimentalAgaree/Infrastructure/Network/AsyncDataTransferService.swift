//
//  AsyncDataTransferService.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 11/26/24.
//

import Foundation
import AsyncNetworkRequest
import CommonNetworkModel

protocol AsyncDataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T
}

final class DefaultAsyncDataTransferService {
    private let _asyncNetworkService: AsyncNetworkService
    
    init(_asyncNetworkService: AsyncNetworkService) {
        self._asyncNetworkService = _asyncNetworkService
    }
}
