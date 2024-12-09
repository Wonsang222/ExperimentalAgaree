//
//  GuessWhoController.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/4/24.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

final class GuessWhoController: UIViewController {
    
    //MARK: - Properties
    
    private let gameViewModel: GuessWhoViewModel
    private var guessView = GuessWhoView()
    private var indicator: UIActivityIndicatorView?

    private let countView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let progressView:UIProgressView = {
        let pv = UIProgressView()
        pv.progressViewStyle = .default
        pv.tintColor = .systemBlue
        pv.isHidden = true
        pv.trackTintColor = .lightGray
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    init(gameViewModel: GuessWhoViewModel) {
        self.gameViewModel = gameViewModel
        super.init(nibName: nil, bundle: nil)
        bind(to: gameViewModel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func removeIndicatorView() {
        indicator?.removeFromSuperview()
    }
    
    private func bind(to viewModel: GuessWhoViewModel) {
        viewModel.error.addObserver(.init(block: {[weak self] in self?.handleError($0)}, target: self))
        viewModel.guessWhoStatus.addObserver(.init(block: { [weak self]  in self?.updateStatus($0)
        }, target: self))
        viewModel.time.addObserver(.init(block: { [weak self] in self?.bindProgressView($0)}, target: self))
        viewModel.target.addObserver(.init(block: { [weak self] in self?.bindImgView($0)}, target: self))
    }
    
    private func handleError(_ error: ErrorHandler?) {
        guard let error = error else { return }
        let script = error.errMsg
        let completion = error.completion
        
        ext.showAlert(title: "알림", message: script, completion: completion)
    }
    
    private func makeIndicatorView() {
        removeIndicatorView()
        indicator = UIActivityIndicatorView(frame: .zero)
        guard let indicator = indicator else { fatalError() }
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            indicator.widthAnchor.constraint(equalTo: indicator.heightAnchor)
        ])
    }
        
    private func updateStatus(_ status: GuessWhoViewModelStatus) {
        switch status {
        case .animation:
            gameViewModel.guessWhoStatus.removeObserver(.init(block: { [weak self] in self?.updateStatus($0)}, target: self))
            startCounter { [weak self] in
                self?.gameViewModel.guessWhoStatus.addObserver(.init(block: { [weak self]  in self?.updateStatus($0)
            }, target: self)) }
        case .ready:
            removeIndicatorView()
        case .waiting:
            makeIndicatorView()
        case .none:
            break
        }
    }
    
    private func bindImgView(_ targetVM: GuessWhoTargetViewModel?) {
        guard let targetVM = targetVM else { return }
        guessView.setPhoto(img: targetVM.photo)
    }
    
    private func bindProgressView(_ second: Float) {
        self.progressView.setProgress(second, animated: true)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    @objc 
    private func viewResignActive() {
        gameViewModel.stopPlayingGame()
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNotification()
    }
    //MARK: - Methods
    private func configureUI() {
        view.addSubview(guessView)
        guessView.addSubview(countView)
        guessView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            guessView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            guessView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            guessView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            guessView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countView.centerXAnchor.constraint(equalTo: guessView.centerXAnchor),
            countView.centerYAnchor.constraint(equalTo: guessView.centerYAnchor),
            countView.heightAnchor.constraint(equalToConstant: 200),
            countView.widthAnchor.constraint(equalToConstant: 200),
            
            progressView.widthAnchor.constraint(equalTo: guessView.widthAnchor, multiplier: 0.5),
            progressView.heightAnchor.constraint(equalToConstant: 20),
            progressView.centerXAnchor.constraint(equalTo: guessView.centerXAnchor),
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
    }
    
    private func startCounter(handler: @escaping () -> Void) {
        UIView.transition(with: countView, duration: 2, options: [.transitionFlipFromTop]) {
            self.countView.image = UIImage(systemName: "3.circle")
            self.countView.layoutIfNeeded()
        } completion: { finished in
            UIView.transition(with: self.countView, duration: 2, options: [.transitionFlipFromTop]) {
                self.countView.image = UIImage(systemName: "2.circle")
                self.countView.layoutIfNeeded()
            } completion: { finished in
                UIView.transition(with: self.countView, duration: 2, options: [.transitionFlipFromTop]) {
                    self.countView.image = UIImage(systemName: "1.circle")
                    self.countView.layoutIfNeeded()
                } completion: { finished in
                    handler()
                }
            }
        }
    }
}

