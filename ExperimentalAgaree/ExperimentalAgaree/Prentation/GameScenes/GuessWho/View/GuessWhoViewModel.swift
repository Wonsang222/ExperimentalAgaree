//
//  GuessWhoViewModel.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/24/24.
//

import Foundation

protocol GuessWhoViewModelInput {
    func viewDidLoad()
    func playAnimation(block: @escaping (_ completion: @escaping () -> Void) -> Void)
    func viewWillDisappear() // 리소스 정리
}

protocol GuessWhoViewModelOutput {
    var target: Observable<GuessWhoTargetViewModel?> { get }
    var time: Observable<Float> { get }
    var error: Observable<String?> { get }
    var guessWhoStatus: Observable<GuessWhoViewModelStatus> { get }
}

enum GuessWhoViewModelStatus {
    case preparation
    case animation
    case ready
    case gaming
    case stop // game stop -> Error  Notification
}

struct GuessWhoViewModelAction {
    let showGameResult: (Bool) -> Void
    let errorHandler: () -> Void
    let startTimer: (GameTimerValue) -> Void
    let fetchGameModelListAction: (FetchGameModelUseCaseRequestValue) -> Void
}

typealias GuessWhoViewModel = GuessWhoViewModelInput & GuessWhoViewModelOutput

final class DefaultGuessWhoViewModel: GuessWhoViewModel {
    
    private let guessWhoUseCase: GuessWhoGameUseCase
    private let actions: GuessWhoViewModelAction
    private let mainQueue: DispatchQueue
    
    private var fetchGameTask: Cancellable?
    private var sttGameTask: Cancellable?
    private var timerGameTask: Cancellable?
    
    //MARK: - Output
    
    let target: Observable<GuessWhoTargetViewModel?> = Observable(value: nil)
    let time: Observable<Float> = Observable(value: 0)
    let error: Observable<String?> = Observable(value: nil)
    let guessWhoStatus: Observable<GuessWhoViewModelStatus> = Observable(value: .preparation)
    
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
        var description: String
        switch error {
        case let netWorkError as DatatransferError:
            description = netWorkError.description
        case let sttError as SpeechError:
            description = sttError.description
        default:
            description = "알수 없는 에러입니다."
        }
        self.error.setValue(description)
    }
    
    private func bind() {
        let vm: Observer<GameModel?> = Observer(block: { [weak self] value in
            let photoImg = value?.photo
            let guessWhoTargetViewModel = GuessWhoTargetViewModel(photo: photoImg)
            self?.target.setValue(guessWhoTargetViewModel)
        }, target: self)
        
        guessWhoUseCase.targetModel.addObserver(vm)
    }
    
    private func fetchGameModelList(targets: FetchGameModelUseCaseRequestValue) {
        fetchGameTask = guessWhoUseCase.fetch(requestValue: targets,
                                              completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.bind()
                self.guessWhoStatus.setValue(.ready)
            case .failure(let err):
                self.handleError(err)
            }
        })
    }
    
    private func startTimer(timerValue: GameTimerValue) {
        timerGameTask = guessWhoUseCase.startTimer(gameTimerValue: timerValue,
                                                   completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .data(let timerInfo):
                let second = timerInfo.gameTime
                self.time.setValue(second)
            case .wrong:
                self.actions.showGameResult(false)
            }
        })
    }
    
    private func startRecognizer() {
        sttGameTask = guessWhoUseCase.startRecognizer(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let judgeResult):
                if case .data(let isClear) = judgeResult {
                    if isClear {
                        actions.showGameResult(isClear)
                    }
                }
            case .failure(let err):
                self.handleError(err)
            }
        })
    }
}

extension DefaultGuessWhoViewModel {

    //MARK: - Input
    
    func viewDidLoad() {
        fetchGameModelList(targets: <#T##FetchGameModelUseCaseRequestValue#>)
    }
    
    func playAnimation(animation: @escaping (_ completion: @escaping () -> Void) -> Void) {
        guessWhoStatus.setValue(.animation)
        animation(viewDidLoad)
    }
    
    func viewWillDisappear() {
        fetchGameTask?.cancel()
        fetchGameTask = nil
        sttGameTask?.cancel()
        sttGameTask = nil
        timerGameTask?.cancel()
        timerGameTask = nil
    }
}
