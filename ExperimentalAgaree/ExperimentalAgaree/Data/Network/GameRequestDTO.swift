//
//  GameRequestDTO.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation

struct GameRequestDTO: Encodable {
    let game: String
    let numberOfPlayers: UInt8
}
