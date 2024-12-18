//
//  GameResultViewModel.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 12/18/24.
//

import UIKit

protocol GameResultViewModelInput {
    func popToRoot()
}

protocol GameResultViewModelOutput {
    var resultString: String { get }
}

struct GameResultViewModelAction {
    let popToRoot: () -> Void
}

typealias GameResultViewModel = GameResultViewModelInput & GameResultViewModelOutput

final class DefaultGameResultViewmodel: GameResultViewModel {
    
    private let gameResultUseCase: GameResultUseCase
    private let action: GameResultViewModelAction
    
    var resultString: String
    
    init(gameResultUseCase: GameResultUseCase,
         action: GameResultViewModelAction
    ) {
        self.gameResultUseCase = gameResultUseCase
        self.action = action
        self.resultString = gameResultUseCase.checkResult()
    }
    
    func popToRoot() {
        action.popToRoot()
    }
}
