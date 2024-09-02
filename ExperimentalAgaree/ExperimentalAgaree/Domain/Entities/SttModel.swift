//
//  SttModel.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import Foundation

struct SttModel {
    let word: String
    
    init(word: String) {
        self.word = word
    }
    
    static func +(lhs: SttModel, rhs: SttModel) -> SttModel {
        return SttModel(word: lhs.word+rhs.word)
    }
}
