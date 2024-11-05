//
//  GuessWhoUseCaseTests.swift
//  ExperimentalAgareeTests
//
//  Created by Wonsang HWang on 11/5/24.
//

import Foundation
@testable import ExperimentalAgaree
import XCTest

let example: GameModelList = {
    let gameModel1 = GameModel(name: "유재석", photoUrl: "https://www.naver.com")
    let gameModel2 = GameModel(name: "제니", photoUrl: "https://www.naver.com")
    let gameModel3 = GameModel(name: "손흥민", photoUrl: "https://www.naver.com")
    let list = GameModelList(gameModels: [gameModel1, gameModel2, gameModel3])
    return list
}()
