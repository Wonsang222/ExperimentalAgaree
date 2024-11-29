//
//  DefaultGameModelImageRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 11/27/24.
//

import Foundation

final class DefaultGameModelImageRepository {
    private let _groupDataTransferService: AsyncGroupDatatransferService
    
    init(
        _groupDataTransferService: AsyncGroupDatatransferService
    ) {
        self._groupDataTransferService = _groupDataTransferService
    }
}

extension DefaultGameModelImageRepository: GameModelImageRepository {
    func fetchImage(path: [String]) async throws -> [Data?] {
        
        let requestDTOArr = path.map { APIEndpoints.getImage(with: $0)}
        let data = await _groupDataTransferService.makeGroupRequest(with: requestDTOArr)
        return data
    }
    
    func fetchImage(path: String) async throws -> Data? {
        let requestDTO = APIEndpoints.getImage(with: path)
        
    }
}
