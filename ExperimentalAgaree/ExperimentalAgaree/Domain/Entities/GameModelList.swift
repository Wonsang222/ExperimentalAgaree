//
//  GameInfo.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/24/24.
//

import Foundation

final class GameModel {
    let name: String?
    let photoUrl: String?
    
    init(name: String?, photoUrl: String?) {
        self.name = name
        self.photoUrl = photoUrl
    }
}

struct GameModelList {
    let gameModels: [GameModel]
}
