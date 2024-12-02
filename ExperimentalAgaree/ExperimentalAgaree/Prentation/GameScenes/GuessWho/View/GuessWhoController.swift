//
//  GuessWhoController.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/4/24.
//

import UIKit

final class GuessWhoController: UIViewController {
    
    //MARK: - Properties
    
    private let gameViewModel: GuessWhoViewModel
    private let guessView = GuessWhoView()

    let countView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let progressView:UIProgressView = {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(to viewModel: GuessWhoViewModel) {
        
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
    
    
//    final func startCounter(handler:@escaping()->Void) {
//        UIView.transition(with: countView, duration: 2, options: [.transitionFlipFromTop]) {
//            self.countView.image = UIImage(systemName: "3.circle")
//            self.countView.layoutIfNeeded()
//        } completion: { finished in
//            UIView.transition(with: self.countView, duration: 2, options: [.transitionFlipFromTop]) {
//                self.countView.image = UIImage(systemName: "2.circle")
//                self.countView.layoutIfNeeded()
//            } completion: { finished in
//                UIView.transition(with: self.countView, duration: 2, options: [.transitionFlipFromTop]) {
//                    self.countView.image = UIImage(systemName: "1.circle")
//                    self.countView.layoutIfNeeded()
//                } completion: { finished in
//                    handler()
//                }
//            }
//        }
//    }
}

