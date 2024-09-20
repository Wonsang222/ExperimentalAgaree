//
//  GameInfo.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/24/24.
//

import UIKit

final class GameModel {
    let name: String
    let photoUrl: String
    var photo: UIImage? = nil
    
    init(name: String, photoUrl: String) {
        self.name = name
        self.photoUrl = photoUrl
    }
}

struct GameModelList {
    let gameModels: [GameModel]
    
    var first: GameModel? {
        return gameModels.first
    }
}
