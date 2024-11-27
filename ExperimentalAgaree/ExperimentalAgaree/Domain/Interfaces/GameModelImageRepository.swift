//
//  GameModelImageRepository.swift
//  ExperimentalAgaree
//
//  Created by Wonsang HWang on 11/27/24.
//

import Foundation

protocol GameModelImageRepository {
    func fetchImage(path: String) async throws -> Data
}
