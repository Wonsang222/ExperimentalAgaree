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
    func tapInstView()
    func tapSeg()
}

protocol GameSelectionViewModelOutput {
    var gameTitle: String { get }
    var errorStr: Observable<String> { get }
}
#warning("temporary param is void")
struct GameSelectionViewModelAction {
    let goPlayGame: () -> Void
}

typealias GameSelectionViewModel = GameSelectionViewModelInput & GameSelectionViewModelOutput

final class DefaultGameSelectionViewModel: GameSelectionViewModel {
    
    private let useCase: GameSelectionUseCase
    private let action: GameSelectionViewModelAction
    private let executionQueue: DispatchQueue
    
    let errorStr: Observable<String> = Observable(value: "")
    
    init(
        useCase: GameSelectionUseCase,
        action: GameSelectionViewModelAction,
        executionQueue: DispatchQueue = DispatchQueue.main
    ) {
        self.useCase = useCase
        self.action = action
        self.executionQueue = executionQueue
    }
    
    func viewDidLoad() {
        
    }
    
    func tapPlayBtn() {
        
        if useCase.checkGameAuthrization() {
            action.goPlayGame()
        }
        
    }
    
    func tapInstView() {
        
    }
    
    func tapSeg() {
        
    }
    
    var gameTitle: String {
        return useCase.getGameTitle()
    }
}
