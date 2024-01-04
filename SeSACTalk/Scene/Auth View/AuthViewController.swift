//
//  AuthViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/03.
//

import UIKit
import RxSwift


class AuthViewController: BaseViewController {
    
    let viewModel = AuthViewModel()
    
    let disposeBag = DisposeBag()
    
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
    
    let signUpButton = {
        let title = "또는 새롭게 회원가입 하기"
        let customTitle = NSMutableAttributedString(string: title)
        customTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 2))
        let button = UIButton()
        button.setTitleColor(Colors.BrandColor.green, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        button.setAttributedTitle(customTitle, for: .normal)
//        button.backgroundColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        let input = AuthViewModel.Input(kakaoLoginButtonClicked: kakaoLoginButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
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
            make.height.equalTo(22)
        }
    }
    
}
