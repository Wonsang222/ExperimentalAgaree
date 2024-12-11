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
    var errorStr: Observable<ErrorHandler?> { get }
    var target: Observable<GameInfo> { get }
}

struct GameSelectionViewModelAction {
    let goPlayGame: (GameInfo, [AuthRepository]) -> Void
}

typealias GameSelectionViewModel = GameSelectionViewModelInput & GameSelectionViewModelOutput

final class DefaultGameSelectionViewModel: GameSelectionViewModel {
    
    private let useCase: GameSelectionUseCase
    private let action: GameSelectionViewModelAction
    
    let errorStr: Observable<ErrorHandler?> = Observable(value: nil)
    let target: Observable<GameInfo>
    
    init(
        useCase: GameSelectionUseCase,
        action: GameSelectionViewModelAction
    ) {
        self.useCase = useCase
        self.action = action
        target = Observable(value: useCase.getTargetModel())
    }

    func viewDidLoad() {
        requestAuthorizations() 
    }
    
    func tapPlayBtn() {
        checkAuthorization { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.action.goPlayGame(self.target.getValue(), useCase._gameAuths)
                return
            }
        }
    }
    //Action
    func tapSeg(_ newValue: UInt8) {
        var currentTargetValue = target.getValue()
        currentTargetValue.setPlayer(original: currentTargetValue, newValue)
        target.setValue(currentTargetValue)
    }
    
    private func buildAuthErrorScript(_ noServices: String) -> String {
        return "게임 실행을 위한 권한이 없습니다. \n 아래의 권한을 설정해주세요. \n \(noServices) "
    }
    
    private func requestAuthorizations() {
        useCase.requestGameAuthorization()
    }
    
    private func checkAuthorization(completion: @escaping (Bool) -> Void) {
        useCase.checkGameAuthrization { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .some(let noServices):
                let noAuthScript = self.buildAuthErrorScript(noServices)
                let errorHandler = ErrorHandler(errMsg: noAuthScript)
                errorStr.setValue(errorHandler)
                completion(false)
            case .none:
                completion(true)
            }
        }
    }
}
