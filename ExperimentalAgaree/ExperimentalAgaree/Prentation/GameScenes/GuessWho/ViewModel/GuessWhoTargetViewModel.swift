//
//  GuessWhoTargetViewModel.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/24/24.
//

import UIKit

struct GuessWhoTargetViewModel {
    let name: String
    let url: String
    var photo: UIImage? = nil
    
    init?(target: GameModel) {
        if let targetName = target.name,
           let targetUrl = target.photoUrl {
            name = targetName
            url = targetUrl
        }
        return nil
    }
}



