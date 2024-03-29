//
//  SignUpViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/07.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    var validation = [true, false, false, false, false]
    
    struct Input {
        let email: ControlProperty<String>
        let nickname: ControlProperty<String>
        let phoneNumber: ControlProperty<String>
        let password: ControlProperty<String>
        let checkPassword: ControlProperty<String>
        
        let validButtonClicked: ControlEvent<Void>
        let signUpButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let emailvalidation: BehaviorSubject<Bool>
        let nicknameValidation: BehaviorSubject<Bool>
        let phoneNumberValidation: BehaviorSubject<Bool>
        let passwordValidation: BehaviorSubject<Bool>
        let checkPaswordValidation: BehaviorSubject<Bool>

        let formattedPhoneNumber: BehaviorSubject<String>
        let signUpButtonActive: BehaviorSubject<Bool>
        let emailValidateButtonActive: BehaviorSubject<Bool>
        
        let emailValidState: PublishSubject<EmailValidationState>
        let signUpValidState: PublishSubject<SignUpState>
        
        let validationArray: BehaviorSubject<Array<Bool>>
//        let validations: Observable<(Bool, Bool, Bool, Bool, Bool)>
    }
    
    func transform(input: Input) -> Output {
        
        let emailValidation = BehaviorSubject(value: false)
        let nicknameValidation = BehaviorSubject(value: false)
        let phoneNumberValidation = BehaviorSubject(value: false)
        let passwordValidation = BehaviorSubject(value: false)
        let checkPaswordValidation = BehaviorSubject(value: false)
        
        let formattedPhoneNumber = BehaviorSubject(value: "")
        let emailValidateButtonActive = BehaviorSubject(value: false)
        let signUpButtonActive = BehaviorSubject(value: false)
        
        let emailValidState = PublishSubject<EmailValidationState>()
        let signUpState = PublishSubject<SignUpState>()
        
        let validationArray: BehaviorSubject<Array<Bool>> = BehaviorSubject(value: [])
        
        
        //이메일 중복 확인 버튼 활성화 여부
        input.email
            .map {
                $0.validateEmail()
            }
            .bind(to: emailValidateButtonActive)
            .disposed(by: disposeBag)
        
        //이메일 검증 버튼 클릭시 API 통신
        input.validButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email)
            .flatMapLatest { email in
                APIManager.shared.emailValidationRequest(api: .emailValidation(model: EmailValidationRequest(email: email)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case.success(_):
                    print("EmailValidation Success")
                    emailValidation.onNext(true)
                    emailValidState.onNext(.isValid)
                case .failure(let error):
                    print("EmailValidation Error", error)
                    emailValidation.onNext(false)
                    emailValidState.onNext(.inValid)
                }
            }
            .disposed(by: disposeBag)
        
        
        //가입 버튼 활성화 여부
        Observable.combineLatest(input.email.map { $0.count > 0 },
                                 input.nickname.map { $0.count > 0 },
                                 input.password.map { $0.count > 0 },
                                 input.checkPassword.map { $0.count > 0 }
        )
        .bind { (isEmailValid, isNicknameValid, isPasswordValid, isCheckPasswordValid) in
            if isEmailValid && isNicknameValid && isNicknameValid && isCheckPasswordValid {
                signUpButtonActive.onNext(true)
            } else {
                signUpButtonActive.onNext(false)
            }
        }
        .disposed(by: disposeBag)
        
        //닉네임 유효성 검증
        input.nickname
            .map {
                $0.count > 1 && $0.count < 31
            }
            .subscribe(with: self) { owner, bool in
//                owner.validation.insert(bool, at: 1)
//                validationArray.onNext(owner.validation)
                nicknameValidation.onNext(bool)
            }
            .disposed(by: disposeBag)
        
        //연락처 유효성 검증
        input.phoneNumber
            .map {
                print("inputPhone", $0)
                let isVaild = $0.validatePhoneNumber()
                
                switch $0.count {
                case 13:
                    let formatted = $0.formated(by: "###-####-####")
                    formattedPhoneNumber.onNext(formatted)
                    print("formatted", formatted)
                default:
                    let formatted = $0.formated(by: "###-###-####")
                    formattedPhoneNumber.onNext(formatted)
                    print("formatted", formatted)
                }
                
                return isVaild
            }
            .subscribe(with: self) { owner, bool in
//                owner.validation.insert(bool, at: 2)
//                validationArray.onNext(owner.validation)
                print("phoneValid", bool)
                phoneNumberValidation.onNext(bool)
            }
            .disposed(by: disposeBag)
        
        
        //비밀번호 유효성 검증
        input.password
            .map {
                $0.validatePassword()
            }
            .subscribe(with: self) { owner, bool in
//                owner.validation.insert(bool, at: 3)
//                validationArray.onNext(owner.validation)
                passwordValidation.onNext(bool)
            }
            .disposed(by: disposeBag)
        
        //비밀번호 확인 유효성 검즘
        Observable.combineLatest(input.password, input.checkPassword)
            .map { password, checkPassword in
                password == checkPassword
            }
            .subscribe(with: self) { owner, bool in
//                owner.validation.insert(bool, at: 4)
//                validationArray.onNext(owner.validation)
                checkPaswordValidation.onNext(bool)
            }
            .disposed(by: disposeBag)
        
        //각 유효성 검증 묶음
        Observable.combineLatest(emailValidation.asObservable(), nicknameValidation.asObservable(), phoneNumberValidation.asObservable(), passwordValidation.asObservable(), checkPaswordValidation.asObservable())
            .map { email, nickname, phoneNumber, password, checkPassword in
                return [email, nickname, phoneNumber, password, checkPassword]
            }
            .subscribe(with: self) { owner, validations in
                validationArray.onNext(validations)
            }
            .disposed(by: disposeBag)
        
        
        let signUpData = Observable.combineLatest(input.email, input.nickname, input.phoneNumber, input.password)
        
        input.signUpButtonClicked
            .withLatestFrom(validationArray)
            .filter { validationArray in
                return validationArray.allSatisfy { $0 == true }
            }
            .withLatestFrom(signUpData)
            .debug()
            .flatMapLatest { email, nickname, phoneNumber, password in
                APIManager.shared.singleRequest(type: SignUpResponse.self, api: .signUp(model: SignUpRequest(email: email, nickname: nickname, phone: phoneNumber , password: password, deviceToken: "")))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                    let token = response.token
                    KeychainManager.shared.create(account: .accessToken, value: response.token.accessToken)
                    KeychainManager.shared.create(account: .refreshToken, value: response.token.refreshToken)
                    KeychainManager.shared.create(account: .userID, value: "\(response.userID)")
                    
                    if KeychainManager.shared.read(account: .workspaceID) == nil {
                        print("WorkspaceID Nil")
                        
                    }
                    //회원 가입 성공 시 WorkSpaceInitialView로 이동
                    SwitchView.shared.switchView(viewController: WorkSpaceInitialView())
                case .failure(let error):
                    print(error)
                    print(SignUpError(rawValue: error.rawValue)?.description)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(emailvalidation: emailValidation, nicknameValidation: nicknameValidation, phoneNumberValidation: phoneNumberValidation, passwordValidation: passwordValidation, checkPaswordValidation: checkPaswordValidation, formattedPhoneNumber: formattedPhoneNumber, signUpButtonActive: signUpButtonActive, emailValidateButtonActive: emailValidateButtonActive, emailValidState: emailValidState, signUpValidState: signUpState, validationArray: validationArray/*, validations: validations*/)
    }
}
