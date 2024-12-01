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

final class GameModel {
    let name: String?
    let photoUrl: String
    var photo: UIImage? = nil
    var photoBinary: Data? = nil
    
    init(name: String?, photoUrl: String) {
        self.name = name
        self.photoUrl = photoUrl
    }
}

final class GameModelList {
    private var gameModels: [GameModel]
    
    var last: GameModel? {
        return gameModels.popLast()
    }
    
    // struct인 경우는 위험한 코드
    var models: [GameModel] {
        return gameModels
    }
    
    init(gameModels: [GameModel]) {
        self.gameModels = gameModels
    }
}
