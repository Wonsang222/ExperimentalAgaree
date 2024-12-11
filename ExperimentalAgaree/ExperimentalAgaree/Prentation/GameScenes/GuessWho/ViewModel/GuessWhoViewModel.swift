//
//  GuessWhoViewModel.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/24/24.
//

import Foundation

protocol GuessWhoViewModelInput {
    func didAnimationFinished()
    func viewWillDisappear() // 리소스 정리
    func stopPlayingGame()
}

protocol GuessWhoViewModelOutput {
    var target: Observable<GuessWhoTargetViewModel?> { get }
    var time: Observable<Float> { get }
    var error: Observable<ErrorHandler?> { get }
    var guessWhoStatus: Observable<GuessWhoViewModelStatus> { get }
}

enum GuessWhoViewModelStatus {
    case animation
    case ready
    case waiting
}

struct GuessWhoViewModelAction {
    let showGameResult: (Bool) -> Void
    let popToRoot: () -> Void
}

typealias GuessWhoViewModel = GuessWhoViewModelInput & GuessWhoViewModelOutput
typealias InnerGuessWhoViewModel = PhotoGameModelable

final class DefaultGuessWhoViewModel: GuessWhoViewModel {
    
    private let guessWhoUseCase: GuessWhoGameUseCase
    private let actions: GuessWhoViewModelAction
    private let mainQueue: DispatchQueue
    private let fetchData: FetchGameModelUseCaseRequestValue
    
    private var fetchGameTask: Cancellable?
    private var sttGameTask: Cancellable?
    private var timerGameTask: Cancellable?
    
    //MARK: - Output
    let target: Observable<GuessWhoTargetViewModel?> = Observable(value: nil)
    let time: Observable<Float> = Observable(value: 0)
    let error: Observable<ErrorHandler?> = Observable(value: nil)
    let guessWhoStatus: Observable<GuessWhoViewModelStatus> = Observable(value: .animation)
    
    init(
        guessWhoUseCase: GuessWhoGameUseCase,
         actions: GuessWhoViewModelAction,
        mainQueue: DispatchQueue = .main,
        fetchData: FetchGameModelUseCaseRequestValue
    ) {
        self.guessWhoUseCase = guessWhoUseCase
        self.actions = actions
        self.mainQueue = mainQueue
        self.fetchData = fetchData
        fetchGameModelList(targets: fetchData)
        bind()
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
        let errorHandler = ErrorHandler(errMsg: description)
        self.error.setValue(errorHandler)
    }
    
    private func bind() {
        guessWhoUseCase.targetModel.addObserver(Observer(block: { [weak self] in self?.setTarget(by: $0)}, target: self))
    }
    
    private func setTarget(by model: GameModelUsable?) {
        guard let model = model else { return }
        mainQueue.async {
            self.target.setValue(.init(photo: UIImage(data: model.photoBinary!)!))
        }
    }

    private func fetchGameModelList(targets: FetchGameModelUseCaseRequestValue) {
        fetchGameTask = guessWhoUseCase.fetch(requestValue: targets,
                                              completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
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
            mainQueue.async {
                switch result {
                case .data(let timerInfo):
                    let second = timerInfo.gameTime
                    self.time.setValue(second)
                case .wrong:
                    self.actions.showGameResult(false)
                }
            }
        })
    }
    
    private func startRecognizer() {
        sttGameTask = guessWhoUseCase.startRecognizer(completion: { [weak self] result in
            guard let self = self else { return }
            self.mainQueue.async {
                switch result {
                case .success(let judgeResult):
                    if case .data(let isClear) = judgeResult {
                        if isClear {
                            self.actions.showGameResult(isClear)
                        }
                    }
                case .failure(let err):
                    self.handleError(err)
                }
            }
        })
    }
    
    private func startGame() {
        if guessWhoStatus.getValue() != .ready {
            let errHandler = ErrorHandler(errMsg: "예상하지 못한 에러입니다.", completion: actions.popToRoot)
            error.setValue(errHandler)
            return
        }
        startTimer(timerValue: fetchData.gameInfo.gameTimeValue)
        startRecognizer()
    }
}

extension DefaultGuessWhoViewModel {
    //MARK: - Input

    func didAnimationFinished() {
        self.startGame()
    }
    
    func viewWillDisappear() {
        fetchGameTask?.cancel()
        fetchGameTask = nil
        sttGameTask?.cancel()
        sttGameTask = nil
        timerGameTask?.cancel()
        timerGameTask = nil
    }
    
    func  stopPlayingGame() {
        let errHandler = ErrorHandler(errMsg: "게임이 중단되었습니다.", completion: actions.popToRoot)
        error.setValue(errHandler)
    }
}
