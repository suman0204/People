//
//  AuthViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/03.
//

import UIKit
import RxSwift


final class AuthViewController: BaseViewController {
    
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
    
    lazy var emailLoginButton = {
        let button = CustomButton(title: nil, setbackgroundColor: nil)
        button.setImage(UIImage(named: "EmailLogin"), for: .normal)
        button.addTarget(self, action: #selector(emailLogInButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpButton = {
        let title = "또는 새롭게 회원가입 하기"
        let customTitle = NSMutableAttributedString(string: title)
        customTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 2))
        let button = UIButton()
        button.setTitleColor(Colors.BrandColor.green, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        button.setAttributedTitle(customTitle, for: .normal)

        button.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func bind() {
        let input = AuthViewModel.Input(kakaoLoginButtonClicked: kakaoLoginButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
    }
    
    @objc
    func signUpButtonClicked() {
        let vc = SignUpViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [
                .large()
            ]
            
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
    
    @objc
    func emailLogInButtonClicked() {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [
                .large()
            ]
            
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
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
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(22)
        }
    }
    
}
