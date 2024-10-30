//
//  PreGameView.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/6/24.
//

import UIKit

final class PreGameView:BaseView{

    // Font Size 바꿈 -> method 사용
    //MARK: - TitleLabel
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let labelContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - SegmentControl
    let segment:UISegmentedControl = {
       let sc = UISegmentedControl(items: ["2인", "3인", "4인", "5인"])
        sc.selectedSegmentTintColor = .systemBlue
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let playButton:LabelButton = {
        let button = LabelButton()
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    let howToPlayButton:UIButton = {
       let button = UIButton()
        let attributes1:[NSAttributedString.Key:Any] = [.font: UIFont.systemFont(ofSize: 16),
                                                       .foregroundColor:UIColor.systemGray]
        let attributes2:[NSAttributedString.Key:Any] = [.font: UIFont.systemFont(ofSize: 16),
                                                       .foregroundColor:UIColor.white]
        let attText1 = NSAttributedString(string: "게임방법이 궁금하신가요?", attributes: attributes1)
        let attText2 = NSAttributedString(string: "좋습니다", attributes: attributes2)
        button.setAttributedTitle(attText1, for: .normal)
        button.setAttributedTitle(attText2, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureTitle() {
        addSubview(labelContainerView)
        
        NSLayoutConstraint.activate([
            labelContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35),
            labelContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            labelContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        ])
    }
    
    private func configureSeg() {
        addSubview(segment)
        NSLayoutConstraint.activate([
            segment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            segment.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func configureLabel() {
        addSubview(howToPlayButton)
        NSLayoutConstraint.activate([
            howToPlayButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            howToPlayButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(playButton)
        let height = frame.maxX * 0.3
        let width = height
        let y = (((howToPlayButton.frame.minY - segment.frame.maxY) / 2) + segment.frame.maxY) - (width / 2)
        let x = frame.midX - (width / 2)
        playButton.frame = CGRect(x: x, y: y, width: width, height: height)
        playButton.layer.cornerRadius = playButton.frame.width / 2
        
        labelContainerView.addSubview(titleLabel)
        let standard = labelContainerView.bounds
        titleLabel.frame = CGRect(x: standard.midX - titleLabel.bounds.width/2,
                                  y: standard.midY - titleLabel.bounds.height/2,
                                  width: standard.width, height: standard.height)
        titleLabel.updateLabelFontSize(view: labelContainerView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configureLabel()
        configureSeg()
        configureTitle()
    }
}
