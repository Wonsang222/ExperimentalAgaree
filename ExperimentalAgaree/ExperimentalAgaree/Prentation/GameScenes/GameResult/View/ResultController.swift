//
//  ResultController.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/4/24.
//

import UIKit

final class ResultController: UIViewController {
    
    private var isWin:Bool
    
    let resultLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        resultLabel.updateLabelFontSize(view: view)
    }
    
    init(isWin: Bool) {
        self.isWin = isWin
        super.init(nibName: nil, bundle: nil)
        checkTheResult()
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkTheResult(){
        if isWin{
            resultLabel.text = "통과~!"
        } else {
            resultLabel.text = "땡~!"
        }
    }
//    
//    func configureEmptyController() {
//        if var stack = navigationController?.viewControllers, let index = stack.firstIndex(of: self){
//            stack.insert(EmptyController(), at: index)
//            navigationController?.viewControllers = stack
//        }
//    }
}
