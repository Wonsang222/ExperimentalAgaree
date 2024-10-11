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

final class PreGameController:BaseController{
    
    private let gameTitle:String
    lazy var preGameView = PreGameView(gameTitle:gameTitle)
    private var howToPlayView:HowToPlayBaseView!
    
    //MARK: - NaviRoot
    
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
        configureNaviBar()
        preGameView.howToPlayButton.addTarget(self, action: #selector(outerButtonTapped), for: .touchUpInside)
        howToPlayView?.button.addTarget(self, action: #selector(innerButtonTapped), for: .touchUpInside)
        preGameView.segment.addTarget(self, action: #selector(segBtnTapped), for: .valueChanged)
    }
    
    init(gameTitle: String) {
        self.gameTitle = gameTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func segBtnTapped(_ sender: UISegmentedControl) {
        
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
    
    func configureNaviBar(){
        let standard = UINavigationBarAppearance()
        standard.configureWithTransparentBackground()
        
        navigationItem.standardAppearance = standard
        navigationItem.scrollEdgeAppearance = standard
        
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .plain, target: self, action: nil)
    }

    func configureView(){
        view.addSubview(preGameView)
        NSLayoutConstraint.activate([
            preGameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            preGameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            preGameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preGameView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func playButtonTapped() {
 
    }
    
    @objc private func showHowToPlay() {
        guard let howToPlayView = howToPlayView else { return }
        view.addSubview(howToPlayView)
        
        NSLayoutConstraint.activate([
            howToPlayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            howToPlayView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            howToPlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            howToPlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

