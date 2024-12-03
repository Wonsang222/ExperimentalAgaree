//
//  GuessWhoTargetViewModel.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/24/24.
//

import UIKit

protocol PhotoGameModelable {
    var photo: UIImage { get }
}

final class GuessWhoTargetViewModel: PhotoGameModelable {
    var photo: UIImage
    
    init(photo: UIImage) {
        self.photo = photo
    }
}



