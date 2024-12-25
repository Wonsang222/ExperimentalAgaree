//
//  ResultController.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/4/24.
//

import UIKit

final class ResultController: UIViewController {
    
    private let resultViewModel: GameResultViewModel
    
    private let resultLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(resultViewModel: GameResultViewModel) {
        self.resultViewModel = resultViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        bind()
        setBehaviors()
        setGameEndBtn()
        
        view.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        resultLabel.updateLabelFontSize(view: view)
    }
    
    private func bind() {
        resultLabel.text = resultViewModel.resultString
    }
    
    private func setBehaviors() {
        addBehaviors([GameEndBtnBehavior()])
    }
    
    private func setGameEndBtn() {
        let btn = navigationItem.rightBarButtonItem!
        btn.target = self
        btn.action = #selector(rightBtnAction)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.rightBarButtonItem?.target = nil
        navigationItem.rightBarButtonItem?.action = nil
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func rightBtnAction() {
        resultViewModel.popToRoot()
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all  )
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            return ResultController(resultViewModel: GameSceneDIContainer.makeTempGameResultVM(isWin: false, action: GameSceneDIContainer.makeTempAction()))
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}


#endif
