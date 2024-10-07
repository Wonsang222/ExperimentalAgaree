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
    
    private let useCase:
    private let action: GameSelectionViewModelAction
    
    func viewDidLoad() {
        
    }
    
    func tapPlayBtn() {
        
    }
    
    func tapInstView() {
        
    }
    
    func tapSeg() {
        
    }
    
    var gameTitle: String
    
    var errorStr: Observable<String>
    
    
}
