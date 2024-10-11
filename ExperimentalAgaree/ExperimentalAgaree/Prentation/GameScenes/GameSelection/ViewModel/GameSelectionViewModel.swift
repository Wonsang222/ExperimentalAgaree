//
//  GameSelectionViewModel.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/7/24.
//

import Foundation

protocol GameSelectionViewModelInput {
    func viewDidLoad()
    func tapPlayBtn()
    func tapSeg(_ newValue: UInt8)
}

protocol GameSelectionViewModelOutput {
    var errorStr: Observable<ErrorHandler> { get }
    var target: Observable<GameInfo> { get }
}

struct GameSelectionViewModelAction {
    let goPlayGame: (GameInfo) -> Void
}

typealias GameSelectionViewModel = GameSelectionViewModelInput & GameSelectionViewModelOutput

final class DefaultGameSelectionViewModel: GameSelectionViewModel {
    
    private let useCase: GameSelectionUseCase
    private let action: GameSelectionViewModelAction
    private let executionQueue: DispatchQueue
    
    let errorStr: Observable<ErrorHandler> = Observable(value: ErrorHandler(errMsg: ""))
    let target: Observable<GameInfo>
    
    init(
        useCase: GameSelectionUseCase,
        action: GameSelectionViewModelAction,
        executionQueue: DispatchQueue = DispatchQueue.main
    ) {
        self.useCase = useCase
        self.action = action
        self.executionQueue = executionQueue
        target = Observable(value: useCase.getTargetModel())
    }
    
    private func reloadTargetModel() {
        target.setValue(useCase.getTargetModel())
    }
    
    func viewDidLoad() {
        
    }
    
    func tapPlayBtn() {
        
        if useCase.checkGameAuthrization() {
            let target = useCase.getTargetModel()
            action.goPlayGame(target)
            return
        }
        
    }

    func tapSeg(_ newValue: UInt8) {
        useCase.setGamePlayer(num: newValue)
        reloadTargetModel()
    }
}
