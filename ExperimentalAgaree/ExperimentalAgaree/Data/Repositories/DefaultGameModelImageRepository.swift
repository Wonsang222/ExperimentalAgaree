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
    // Task 연습(부분적용)을 위한, 임시 코드
    func fetchImages(paths: GameModelList, completion: @escaping (GameModelList) -> Void) async {
        await withTaskGroup(of: Void.self) { [weak self] group in
            for path in paths.models {
                group.addTask { [weak self]  in
                    path.photoBinary = try? await self?.fetchImage(path: path.photoUrl)
                }
            }
            
            await group.waitForAll()
            completion(paths)
        }
    }

    func fetchImage(path: String) async throws -> Data? {
        let requestDTO = APIEndpoints.getImage(with: path)
        let data = await _groupDataTransferService.makeGroupRequest(with: requestDTO)
        return data
    }
    
    func fetchImages(path: [String]) async throws -> [Data?] {
        
        let requestDTOArr = path.map { APIEndpoints.getImage(with: $0)}
        let data = await _groupDataTransferService.makeGroupRequests(with: requestDTOArr)
        return data
    }
}
