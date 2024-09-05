//
//  GameType.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/3/24.
//

import Foundation

enum GameType: String {
    case guessWho
    
    func getKoreaTitle() -> String {
        switch self {
        case .guessWho:
            return "인물퀴즈"
        default:
            return ""
        }
    }
}
