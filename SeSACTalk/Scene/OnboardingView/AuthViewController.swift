//
//  AuthViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/03.
//

import UIKit

class AuthViewController: BaseViewController {
    
    let appleLoginButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AppleIDLogin"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFill
//        button.backgroundColor = .lightGray
        return button
    }()
    
    let kakaoLoginButton = {
        let button = CustomButton(title: nil, setbackgroundColor: nil)
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        return button
    }()
    
    let emailLoginButton = {
        let button = CustomButton(title: nil, setbackgroundColor: nil)
        button.setImage(UIImage(named: "EmailLogin"), for: .normal)
        return button
    }()
    
    let signUpButton = CustomButton(title: "새롭게 회원가입", setbackgroundColor: .blue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [appleLoginButton, kakaoLoginButton, emailLoginButton, signUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalTo(44)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalTo(44)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.height.equalTo(44)
        }
    }
    
}
