//
//  GameResponseDTO.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation

final class GameModelInfo: Decodable {
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

struct GameResponseDTO: Decodable {
    let gameModelList: [GameModelInfo]
}

extension GameResponseDTO {
    func toDomain() -> GameModelList {
        let models = gameModelList.map { GameModel(name: $0.name, photoUrl: $0.url) }
        return .init(gameModels: models)
    }
}
