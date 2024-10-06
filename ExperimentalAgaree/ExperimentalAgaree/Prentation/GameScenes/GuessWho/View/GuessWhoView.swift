//
//  GuessWhoView.swift
//  ExperimentalAgaree
//
//  Created by Wonsang HWang on 10/4/24.
//

import UIKit

final class GuessWhoView: BaseView {
    
    let imageView:UIImageView = {
       let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.image = UIImage(systemName: "trash")
        imgView.contentMode = .scaleToFill
        imgView.isHidden = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [imageView].forEach {addSubview($0)}
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            imageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
        ])
    }
}

