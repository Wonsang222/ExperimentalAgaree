//
//  GuessWhoGameModel.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/24/24.
//

import UIKit

final class GuessWhoGameModel {
    let name: String?
    let photo: UIImage?
    
    init(name: String?, photo: UIImage?) {
        self.name = name
        self.photo = photo
    }
}


struct GuessWhoGameList {
    let models: [GuessWhoGameModel]
}
