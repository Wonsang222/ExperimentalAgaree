//
//  GuessWhoTargetViewModel.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/24/24.
//

import UIKit

protocol SttGameModelable {
    var name: String { get }
}
protocol PhotoGameModelable {
    var photo: UIImage { get }
}

final class GuessWhoTargetViewModel: SttGameModelable, PhotoGameModelable {
    let name: String
    var photo: UIImage
    
    init(name: String, photo: UIImage) {
        self.name = name
        self.photo = photo
    }
}



