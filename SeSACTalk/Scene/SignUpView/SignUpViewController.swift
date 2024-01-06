//
//  SignUpViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/06.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    lazy var emailTextFieldView = {
        let view = SignUpTextFieldView(type: .withButton)
//        view.type = .withButton
        view.type = .withButton
        view.labelText = "이메일"
        view.placeholder = "이메일을 입력하세요"
        return view
    }()
    
    let nicknameTextFieldView = {
        let view = SignUpTextFieldView(type: .normal)
        view.type = .normal
        view.labelText = "닉네임"
        view.placeholder = "닉네임을 입력하세요"
        return view
    }()
    
    let contactTextFieldView = {
        let view = SignUpTextFieldView(type: .normal)
        view.type = .normal
        view.labelText = "연락처"
        view.placeholder = "연락처를 입력하세요"
        return view
    }()
    
    let passwordTextFieldView = {
        let view = SignUpTextFieldView(type: .normal)
        view.type = .normal
        view.labelText = "비밀번호"
        view.placeholder = "비밀번호를 입력하세요"
        return view
    }()
    
    let checkPasswordTextFieldView = {
        let view = SignUpTextFieldView(type: .normal)
        view.type = .normal
        view.labelText = "비밀번호 확인"
        view.placeholder = "비밀번호를 한 번 더 입력하세요"
        return view
    }()
    
    let signUpButton = CustomButton(title: "가입하기", setbackgroundColor: Colors.BrandColor.inactive)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextFieldView.type = .withButton
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BackgroundColor.primary
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundColor.secondary
//        self.navigationController?.navigationBar.shadowImage = nil
    
        self.title = "회원가입"
        
        [emailTextFieldView, nicknameTextFieldView, contactTextFieldView, passwordTextFieldView, checkPasswordTextFieldView, signUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
        }
        
        nicknameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(76)
        }
        
        contactTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(76)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(contactTextFieldView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(76)
        }
        
        checkPasswordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(76)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
            make.top.lessThanOrEqualTo(checkPasswordTextFieldView.snp.bottom).offset(147)
        }
        
    }
}
