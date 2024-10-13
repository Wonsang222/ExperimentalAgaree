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

    func viewDidLoad() {
        requestAuthorizations() 
    }
    
    func tapPlayBtn() {
        checkAuthorization { [weak self] in
            guard let self = self else { return }
            self.action.goPlayGame(self.target.getValue())
        }
    }

    func tapSeg(_ newValue: UInt8) {
        var currentTargetValue = target.getValue()
        let newTargetValue = currentTargetValue.setPlayer(newValue)
        target.setValue(newTargetValue)
    }
    
    private func buildAuthErrorScript(_ noServices: String) -> String {
        return "게임 실행을 위한 권한이 없습니다. \n 아래의 권한을 설정해주세요. \n \(noServices) "
    }
    
    private func requestAuthorizations() {
        useCase.requestGameAuthorization()
    }
    
    private func checkAuthorization(completion: @escaping () -> Void) {
        useCase.checkGameAuthrization { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .some(let noService):
                let noAuthScript = self.buildAuthErrorScript(noService)
                let errorHandler = ErrorHandler(errMsg: noAuthScript)
                errorStr.setValue(errorHandler)
            case .none:
                completion()
            }
        }
    }
}
