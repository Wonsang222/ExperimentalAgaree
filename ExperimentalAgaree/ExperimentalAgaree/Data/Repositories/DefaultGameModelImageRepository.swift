//
//  DefaultGameModelImageRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 11/27/24.
//

import Foundation

final class DefaultGameModelImageRepository {
    private let _dataTransferService: AsyncDataTransferService
    
    init(
        _dataTransferService: AsyncDataTransferService
    ) {
        self._dataTransferService = _dataTransferService
    }
}

extension DefaultGameModelImageRepository: GameModelImageRepository {
    func fetchImage(path: String) async throws -> Data {
        
        let requestDTO = APIEndpoints.getImage(with: path)
        let data = try await _dataTransferService.request(with: requestDTO)
        return data
    }
}
