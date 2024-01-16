//
//  LoginViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/15.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
    let viewModel = LogInViewModel()
    let disposeBag = DisposeBag()
    
    let emailTextFieldView = {
        let view = SignUpTextFieldView(type: .normal)
        view.labelText = "이메일"
        view.placeholder = "이메일을 입력하세요"
        view.validButton.isEnabled = false
        return view
    }()
    
    let passwordTextFieldView = {
        let view = SignUpTextFieldView(type: .normal)
        view.labelText = "비밀번호"
        view.placeholder = "비밀번호를 입력하세요"
        view.validButton.isEnabled = false
        return view
    }()
    
    let logInButton = CustomButton(title: "로그인", setbackgroundColor: Colors.BrandColor.inactive)

    //dismiss Button
    lazy var dismissButton = {
        let button = UIBarButtonItem(image: UIImage(named: "Xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        button.tintColor = Colors.BrandColor.black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func bind() {
        
        let input = LogInViewModel.Input(email: emailTextFieldView.inputTextField.rx.text.orEmpty, password: passwordTextFieldView.inputTextField.rx.text.orEmpty, logInButtonClicked: logInButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        //로그인 버튼 활성화 여부
        output.logInButtonActive
            .bind(with: self) { owner, bool in
                let color: UIColor = bool ? Colors.BrandColor.green : Colors.BrandColor.inactive
                owner.logInButton.backgroundColor = color
                owner.logInButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        //각 텍스트필드 유쇼성
        output.validationArray
            .subscribe(with: self) { owner, array in
                print("Login == ",array)
            }
            .disposed(by: disposeBag)
        
        //로그인 버튼 클릭 시
        let textFieldArray = [emailTextFieldView, passwordTextFieldView]
        
        logInButton.rx.tap
            .subscribe(with: self) { owner, _ in
                guard let invalidIndex = try? output.validationArray.value().firstIndex(of: false) else {
                    textFieldArray.forEach {
                        $0.titleLabel.textColor = Colors.BrandColor.black
                    }
                    return
                }
//                textFieldArray.forEach { $0.textColor = Colors.BrandColor.black }

                for (index, bool) in try! output.validationArray.value().enumerated() {
                    if bool == false {
                        textFieldArray[index].titleLabel.textColor = Colors.BrandColor.error
//                        owner.showToast(message: SignUpState(rawValue: index)?.description ?? "")
                    } else {
                        textFieldArray[index].titleLabel.textColor = Colors.BrandColor.black
                    }
                }
                    
                textFieldArray[invalidIndex].inputTextField.becomeFirstResponder()
                owner.showToast(message: LogInState(rawValue: invalidIndex)?.description ?? "")

            }
            .disposed(by: disposeBag)
        
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BackgroundColor.primary
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundColor.secondary
        
        self.navigationItem.leftBarButtonItem = dismissButton
    
        self.title = "이메일 로그인"
        
        [emailTextFieldView, passwordTextFieldView, logInButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(76)
        }
        
        logInButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
            make.top.lessThanOrEqualTo(passwordTextFieldView.snp.bottom).offset(447)
        }
    }
}

extension LoginViewController {
    
    @objc
    func dismissButtonClicked() {
        self.dismiss(animated: true)
    }
}
