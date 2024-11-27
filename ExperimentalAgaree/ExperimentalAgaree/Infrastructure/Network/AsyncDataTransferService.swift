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
    
    private func decode<T: Decodable>(decoder: ResponseDecoder, data: Data) throws  -> T {
        
        do {
            return try decoder.decode(data)
        } catch {
            throw DatatransferError.parsing(error)
        }
    }
    
    private func makeRequest(endpoint: Requestable) async throws -> Data {
        do {
            let data = try await _asyncNetworkService.request(endpoint: endpoint)
            return data
        } catch {
            throw resolve(err: error)
        }
    }
    
    private func resolve(err: Error) -> DatatransferError {
        if let netErr = err as? NetworkError {
            return .networkFailure(netErr)
        }
        return .resolvedNetworkFailure(err)
    }
}

extension DefaultAsyncDataTransferService: AsyncDataTransferService {
    
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T{
        let data = try await _asyncNetworkService.request(endpoint: endpoint)
        return try decode(decoder: endpoint.responseDecoder, data: data)
    }
}


final class RawDataResponseDecoder: ResponseDecoder {
    
    private enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if T.self is Data.Type,
           let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data Type")
            throw DecodingError.typeMismatch(T.self, context)
        }
    }
}


protocol AsyncGroupDatatransferService {
    func makeGroupRequest<T: Decodable, E: ResponseRequestable>(with endpoints: [E]) async throws -> [T?] where E.Response == T
}

final class DefaultAsyncGroupDatatransferService {
    private let _asyncDatatransferService: AsyncDataTransferService
    
    init(_asyncDatatransferService: AsyncDataTransferService) {
        self._asyncDatatransferService = _asyncDatatransferService
    }
}

extension DefaultAsyncGroupDatatransferService: AsyncGroupDatatransferService {
    func makeGroupRequest<T, E>(with endpoints: [E]) async throws -> [T?] where T : Decodable, T == E.Response, E : CommonNetworkModel.ResponseRequestable {
        
        try await withThrowingTaskGroup(of: T?.self,
                                        returning: [T?].self
        ) { group in
            
            var imageArr = [T]()
            
            for endpoint in endpoints {
                group.addTask { [weak self] in
                    guard let self = self else { return nil }
                    return try await self._asyncDatatransferService.request(with: endpoint)
                }
            }
            

            
            
            return imageArr
        }
    }
}
