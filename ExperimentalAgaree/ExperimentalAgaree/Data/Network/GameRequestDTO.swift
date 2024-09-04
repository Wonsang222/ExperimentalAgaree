//
//  GameRequestDTO.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation

struct GameRequestDTO: Encodable {
    let game: GameType
    let numberOfPlayers: UInt8
    
    private enum CodingKeys: String, CodingKey {
        case numberOfPlayers
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(numberOfPlayers, forKey: .numberOfPlayers)
    }
}
