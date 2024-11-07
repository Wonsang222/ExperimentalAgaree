//
//  GameInfo.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/24/24.
//

import UIKit

struct NullGameModel {
    let name = "조커"
    let photo = #imageLiteral(resourceName: "joker")
}

struct GameModel {
    let name: String?
    let photoUrl: String?
    var photo: UIImage? = nil
    
    init(name: String?, photoUrl: String?) {
        self.name = name
        self.photoUrl = photoUrl
    }
}

final class GameModelList {
    private var gameModels: [GameModel]
    
    var last: GameModel? {
        return gameModels.popLast()
    }
    
    var models: [GameModel] {
        return gameModels
    }
    
    init(gameModels: [GameModel]) {
        self.gameModels = gameModels
    }
}
