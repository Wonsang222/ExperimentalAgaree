//
//  PreGameController.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/4/24.
//

import UIKit

class BaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
}

final class PreGameController: BaseController{
    
    private lazy var preGameView = PreGameView()
    private var howToPlayView:HowToPlayBaseView!
    private let gameSelectionViewModel: GameSelectionViewModel!

    //MARK: - NaviRoot

    init(gameSelectionViewModel: GameSelectionViewModel) {
        self.gameSelectionViewModel = gameSelectionViewModel
        super.init(nibName: nil, bundle: nil)
        bind(to: self.gameSelectionViewModel)
        
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(to viewModel: GameSelectionViewModel) {
        gameSelectionViewModel.target.addObserver(Observer(block: { [weak self] in self?.updateUI($0)}, target: self))
    }
    
    private func updateUI(_ gameInfo: GameInfo) {
        let title = gameInfo.getGameTitle()
        let instView = gameInfo.getGamePath().instView
        
        preGameView.titleLabel.text = title
        howToPlayView = instView
    }
   
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        preGameView.playButton.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        preGameView.howToPlayButton.addTarget(self, action: #selector(outerButtonTapped), for: .touchUpInside)
        howToPlayView?.button.addTarget(self, action: #selector(innerButtonTapped), for: .touchUpInside)
        preGameView.segment.addTarget(self, action: #selector(segBtnTapped), for: .valueChanged)
        
        gameSelectionViewModel.viewDidLoad()
    }
    
    @objc private func segBtnTapped(_ sender: UISegmentedControl) {
        let num = sender.selectedSegmentIndex + 2
        gameSelectionViewModel.tapSeg(UInt8(num))
    }
    
    @objc private func innerButtonTapped(){
        howToPlayView?.removeFromSuperview()
    }
    
    @objc private func outerButtonTapped() {
        guard let howToPlayView = howToPlayView else { return }
        view.addSubview(howToPlayView)
        NSLayoutConstraint.activate([
            howToPlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            howToPlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            howToPlayView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            howToPlayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
        howToPlayView.layoutIfNeeded()
    }

    private func configureView() {
        view.addSubview(preGameView)
        NSLayoutConstraint.activate([
            preGameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            preGameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            preGameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preGameView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func playButtonTapped() {
        gameSelectionViewModel.tapPlayBtn()
    }
}

