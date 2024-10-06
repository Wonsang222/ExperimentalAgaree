//
//  UILabel + UIButton.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/6/24.
//

import UIKit

class LabelButton:UIView{
    
    private let buttonLabel:UILabel = {
        let label = UILabel()
        label.text = "플레이"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
        
    private let buttonImage:UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "play.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let playButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStack:UIStackView = {
       let st = UIStackView(arrangedSubviews: [buttonImage, buttonLabel])
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .center
        st.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        st.isLayoutMarginsRelativeArrangement = true
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBlue
        addSubview(buttonStack)
        addSubview(playButton)
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: topAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            buttonStack.topAnchor.constraint(equalTo: playButton.topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: playButton.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: playButton.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: playButton.trailingAnchor),
            
            buttonImage.widthAnchor.constraint(equalTo: buttonStack.widthAnchor, multiplier: 0.5),
        ])
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
