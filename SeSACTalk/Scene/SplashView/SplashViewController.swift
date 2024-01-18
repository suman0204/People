//
//  SplashViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/02.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    let splashTextLabel = {
        let label = UILabel()
        label.text = "새싹톡을 사용하면 어디서나 \n 팀을 모을 수 있습니다"
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let splashImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "onboarding")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [splashTextLabel, splashImageView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        splashTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(93)
            make.height.equalTo(60)
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerX.equalToSuperview()
            
        }
        
        splashImageView.snp.makeConstraints { make in
            make.top.equalTo(splashTextLabel.snp.bottom).offset(89)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(splashImageView.snp.width)
        }
    }
}
