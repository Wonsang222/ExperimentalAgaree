//
//  GameModelImageRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang HWang on 11/27/24.
//

import Foundation

protocol GameModelImageRepository {
    
    func fetchImages(paths: GameModelList, completion: @escaping (GameModelList) -> Void) async
    func fetchImages(path: [String]) async throws -> [Data?]
    func fetchImage(path: String) async throws -> Data?
}
