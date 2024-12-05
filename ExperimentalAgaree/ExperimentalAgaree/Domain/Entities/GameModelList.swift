//
//  GameInfo.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/24/24.
//

import UIKit

protocol GameModelUsable {
    var name: String { get }
    var photoUrl: String { get }
    var photoBinary: Data? { get set }
}

final class GameClearModel: GameModelUsable {
    let name: String = "끝"
    let photoUrl: String = "temp"
    var photoBinary: Data? = nil
}

final class NullGameModel: GameModelUsable {
    let name = "조커"
    let photoUrl: String = try! String(contentsOf: Bundle.main.url(forResource: "joker", withExtension: "jpg")!)
    var photoBinary: Data? = nil
}

final class GameModel: GameModelUsable {
    let name: String
    let photoUrl: String
    var photoBinary: Data? = nil
    
    init(name: String, photoUrl: String) {
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
