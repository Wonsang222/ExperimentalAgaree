//
//  GuessWhoViewModel.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/24/24.
//

import Foundation

protocol GuessWhoViewModelInput {
    func viewDidLoad()
    func viewWillDisappear() // 리소스 정리
}

protocol GuessWhoViewModelOutput {
    var models: Observable<[GuessWhoTargetViewModel]> { get }
}

enum GuessWhoViewModelStatus {
    case animating
    case fetching
    case ready
    case gaming
    case stop // game stop -> Error
}

struct GuessWhoViewModelAction {
    let showGameResult: (Bool) -> Void
    
}

typealias GuessWhoViewModel = GuessWhoViewModelInput & GuessWhoViewModelOutput

final class DefaultGuessWhoViewModel: GuessWhoViewModel {
    
    private let guessWhoUseCase: GuessWhoGameUseCase
    private let mainQueue: DispatchQueue
    
    private let fetchGameTask: Cancellable?
    private let sttGameTask: Cancellable?
    private let timerGameTask: Cancellable?
    
    
    
}
