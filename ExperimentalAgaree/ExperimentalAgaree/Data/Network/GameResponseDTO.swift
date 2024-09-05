//
//  GameResponseDTO.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation

protocol GameModelUsable {
    var name: String? { get }
    var url: String? { get }
}

class GameResponseDTO: Decodable, GameModelUsable {
    let name: String?
    let url: String?
    
    init(name: String?, url: String?) {
        self.name = name
        self.url = url
    }
}
