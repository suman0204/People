//
//  SignUpViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/06.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    lazy var emailTextFieldView = {
        let view = SignUpTextFieldView(type: .withButton)
        view.type = .withButton
        view.labelText = "이메일"
        view.placeholder = "이메일을 입력하세요"
        view.validButton.isEnabled = false

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
    
    //dismiss Button
    lazy var dismissButton = {
        let button = UIBarButtonItem(image: UIImage(named: "Xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        button.tintColor = Colors.BrandColor.black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        
        let input = SignUpViewModel.Input(email: emailTextFieldView.inputTextField.rx.text.orEmpty, nickname: nicknameTextFieldView.inputTextField.rx.text.orEmpty, contact: contactTextFieldView.inputTextField.rx.text.orEmpty, password: passwordTextFieldView.inputTextField.rx.text.orEmpty, checkPassword: checkPasswordTextFieldView.inputTextField.rx.text.orEmpty, validButtonClicked: emailTextFieldView.validButton.rx.tap, signUpButtonClicked: signUpButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.emailvalidation
            .subscribe(with: self) { owner, bool in
                let color: UIColor = bool ? Colors.BrandColor.green : Colors.BrandColor.inactive
                owner.emailTextFieldView.validButton.backgroundColor = color
                owner.emailTextFieldView.validButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        emailTextFieldView.validButton.rx.tap
            .subscribe(with: self) { owner, _ in
                print("clicked")
            }
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(with: self) { owner, _ in
                print("clicked")
            }
            .disposed(by: disposeBag)
        
        output.signUpButtonActive
            .subscribe(with: self) { owner, bool in
                let color: UIColor = bool ? Colors.BrandColor.green : Colors.BrandColor.inactive
                owner.signUpButton.backgroundColor = color
                owner.signUpButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BackgroundColor.primary
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundColor.secondary
        
        self.navigationItem.leftBarButtonItem = dismissButton
    
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

extension SignUpViewController {
    
    @objc
    func dismissButtonClicked() {
        self.dismiss(animated: true)
    }
}
