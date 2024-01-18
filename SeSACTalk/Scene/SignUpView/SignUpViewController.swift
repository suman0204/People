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
    
    let phoneNumberTextFieldView = {
        let view = SignUpTextFieldView(type: .normal)
        view.type = .normal
        view.labelText = "연락처"
        view.placeholder = "연락처를 입력하세요"
//        view.inputTextField.text = view.inputTextField.text?.formated(by: "###-####-####")
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
        
        APIManager.shared.emailValidationRequest(api: Router.emailValidation(model: EmailValidationRequest(email: "0208@0204.com")))
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let data):
                    print(data)
                case.failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        

    }
    
    override func bind() {
        
        let input = SignUpViewModel.Input(email: emailTextFieldView.inputTextField.rx.text.orEmpty, nickname: nicknameTextFieldView.inputTextField.rx.text.orEmpty, phoneNumber: phoneNumberTextFieldView.inputTextField.rx.text.orEmpty, password: passwordTextFieldView.inputTextField.rx.text.orEmpty, checkPassword: checkPasswordTextFieldView.inputTextField.rx.text.orEmpty, validButtonClicked: emailTextFieldView.validButton.rx.tap, signUpButtonClicked: signUpButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        //중복확인버튼 배경색 및 활성화
        output.emailValidateButtonActive
            .subscribe(with: self) { owner, bool in
                let color: UIColor = bool ? Colors.BrandColor.green : Colors.BrandColor.inactive
                owner.emailTextFieldView.validButton.backgroundColor = color
                owner.emailTextFieldView.validButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        output.emailValidState
            .subscribe(with: self) { owner, state in
                print(state.description)
                owner.showToast(message: state.description)
            }
            .disposed(by: disposeBag)
        
        //연락처 입력된 값 표기 형식
        output.formattedPhoneNumber
            .distinctUntilChanged()
            .bind(to: phoneNumberTextFieldView.inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        emailTextFieldView.validButton.rx.tap
            .subscribe(with: self) { owner, _ in
                print("clicked")
            }
            .disposed(by: disposeBag)
        
//        signUpButton.rx.tap
//            .subscribe(with: self) { owner, _ in
//                print("clicked")
//                owner.showToast(message: "사용 가능한 이메일입니다.")
//            }
//            .disposed(by: disposeBag)
        
        //가입버튼 배경색 및 활성화
        output.signUpButtonActive
            .subscribe(with: self) { owner, bool in
                let color: UIColor = bool ? Colors.BrandColor.green : Colors.BrandColor.inactive
                owner.signUpButton.backgroundColor = color
                owner.signUpButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        //가입버튼 클릭 시
        let textFieldArray = [emailTextFieldView, nicknameTextFieldView, phoneNumberTextFieldView, passwordTextFieldView, checkPasswordTextFieldView]
        
        signUpButton.rx.tap
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
                owner.showToast(message: SignUpState(rawValue: invalidIndex)?.description ?? "")

            }
            .disposed(by: disposeBag)
        
        output.validationArray
            .subscribe(with: self) { owner, array in
                print(array)
            }
            .disposed(by: disposeBag)
//            .subscribe(with: self) { owner, _ in
//                // output의 validationArray에서 false인 부분을 찾아서 처리
//                guard let invalidIndex = try? output.validationArray.value().firstIndex(of: false) else {
//                    return
//                }
//                
//                // 타이틀 색을 초기화
//                textFieldArray.forEach { $0.textColor = Colors.BrandColor.black }
//                
//                // 찾은 부분의 타이틀 색을 빨간색으로 변경하고 해당 텍스트필드에 포커스를 줌
//                textFieldArray[invalidIndex].textColor = Colors.BrandColor.error
//                textFieldArray[invalidIndex].becomeFirstResponder()
//            }
//            .disposed(by: disposeBag)
        
//        let valid = BehaviorSubject(value: [output.emailvalidation, output.nicknameValidation, output.phoneNumberValidation, output.passwordValidation, output.checkPaswordValidation])
//        let validationArray = [output.emailvalidation, output.nicknameValidation, output.phoneNumberValidation, output.passwordValidation, output.checkPaswordValidation]
//
//        
//        for (index, validation) in valid.enumerated() {
//            if try! validation.value() == false {
//                textFieldArray[index].textColor = Colors.BrandColor.error
//            } else {
//                textFieldArray[index].textColor = Colors.BrandColor.black
//            }
//        }
//        Observable<BehaviorSubject<Bool>>.of(output.emailvalidation, output.nicknameValidation, output.phoneNumberValidation, output.passwordValidation, output.checkPaswordValidation)
//            .subscribe(with: self) { owner, bool in
//                if bool == false {
//                    
//                }
//            }
        
        
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BackgroundColor.primary
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundColor.secondary
        
        self.navigationItem.leftBarButtonItem = dismissButton
    
        self.title = "회원가입"
        
        [emailTextFieldView, nicknameTextFieldView, phoneNumberTextFieldView, passwordTextFieldView, checkPasswordTextFieldView, signUpButton].forEach {
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
        
        phoneNumberTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(76)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextFieldView.snp.bottom).offset(24)
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
