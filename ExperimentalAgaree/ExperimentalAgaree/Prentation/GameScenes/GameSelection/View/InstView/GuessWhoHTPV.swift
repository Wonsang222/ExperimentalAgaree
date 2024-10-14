//
//  HowToPlayBaseView.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 10/14/24.
//

import UIKit

final class GuessWhoHTPV: HowToPlayBaseView {
        
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContainer()
        addSubview(mainTitle)
        addSubview(containerView)
        addSubview(button)

        NSLayoutConstraint.activate([
            mainTitle.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            mainTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            containerView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 50),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            button.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 50),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContainer(){
        let imgView:UIImageView = {
            let imgView = UIImageView(image: UIImage(named: "joker")!.withRenderingMode(.alwaysOriginal))
            imgView.contentMode = .scaleAspectFit
            imgView.translatesAutoresizingMaskIntoConstraints = false
            return imgView
        }()
        
        let descriptionLabel1:UILabel = {
            let label = UILabel()
            label.text = "인물의 이름을 외쳐주세요"
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            label.font = .preferredFont(forTextStyle: .body)
            label.backgroundColor = .black
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let descriptionLabel2:UILabel = {
            let label = UILabel()
            label.text = "게임시간은 4초, 기회는 1인당 1번!"
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            // trait이 궁금해진다
            label.font = .preferredFont(forTextStyle: .body)
            label.backgroundColor = .black
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let descriptionLabel3:UILabel = {
            let label = UILabel()
            label.text = "아래의 사진과 같이 \n종종 보너스 카드가 나옵니다.\n 조커!라고 외쳐주세요"
            label.numberOfLines = 3
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            // trait이 궁금해진다
            label.font = .preferredFont(forTextStyle: .body)
            label.backgroundColor = .black
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
                          
        imgView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        containerView.addArrangedSubview(descriptionLabel1)
        containerView.addArrangedSubview(descriptionLabel2)
        containerView.addArrangedSubview(descriptionLabel3)
        containerView.addArrangedSubview(imgView)
        
        imgView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8).isActive = true
    }
}
