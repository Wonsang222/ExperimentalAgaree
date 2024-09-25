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
    var target: Observable<GuessWhoTargetViewModel?> { get }
    var time: Observable<Float> { get }
    var error: Observable<Error?> { get }
    var guessWhoStatus: Observable<GuessWhoViewModelStatus> { get }
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
    let errorHandler: () -> Void
    let fetchGameModelListAction: (@escaping (FetchGameModelUseCaseRequestValue) -> Void) -> Void
}

typealias GuessWhoViewModel = GuessWhoViewModelInput & GuessWhoViewModelOutput

final class DefaultGuessWhoViewModel: GuessWhoViewModel {
    
    private let guessWhoUseCase: GuessWhoGameUseCase
    private let actions: GuessWhoViewModelAction
    private let mainQueue: DispatchQueue
    
    private var fetchGameTask: Cancellable?
    private var sttGameTask: Cancellable?
    private var timerGameTask: Cancellable?
    
    // mark
    
    let target: Observable<GuessWhoTargetViewModel?> = Observable(value: nil)
    let time: Observable<Float> = Observable(value: 0)
    let error: Observable<Error?> = Observable(value: nil)
    let guessWhoStatus: Observable<GuessWhoViewModelStatus> = Observable(value: .stop)
    
    init(
        guessWhoUseCase: GuessWhoGameUseCase,
        actions: GuessWhoViewModelAction,
        mainQueue: DispatchQueue = DispatchQueue.main
    ) {
        self.guessWhoUseCase = guessWhoUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    private func handleError(_ error: Error) {
        
    }
    
    private func fetchGameModelList(targets: FetchGameModelUseCaseRequestValue) {
        fetchGameTask = guessWhoUseCase.fetch(requestValue: targets, completion: { result in
            switch result {
            case .success():
                print(123)
            case .failure(let err):
                print(123)
            }
        })
    }
}

extension DefaultGuessWhoViewModel {
    func viewDidLoad() {
        actions.fetchGameModelListAction(fetchGameModelList(targets:))
    }
    
    func viewWillDisappear() {
        
    }
}
