//
//  LogInViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/15.
//

import Foundation
import RxSwift
import RxCocoa

class LogInViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let logInButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let logInButtonActive: BehaviorRelay<Bool>
        let validationArray: BehaviorSubject<Array<Bool>>
    }
    
    func transform(input: Input) -> Output {
        
        let logInButtonActive = BehaviorRelay(value: false)
        
        let emailValid = BehaviorSubject(value: false)
        let passwowordValid = BehaviorSubject(value: false)
        
        let validationArray: BehaviorSubject<Array<Bool>> = BehaviorSubject(value: [])
        
        //로그인 버튼 활성화
        Observable.combineLatest(input.email, input.password)
            .map { email, password in
                return email.count > 0 && password.count > 0
            }
            .subscribe(with: self) { owner, bool in
                logInButtonActive.accept(bool)
            }
            .disposed(by: disposeBag)
        
        //이메일 유효성 검증
        input.email
            .map {
                $0.validateEmail()
            }
            .bind(to: emailValid)
            .disposed(by: disposeBag)
        
        //비밀번호 유효성 검증
        input.password
            .map {
                $0.validatePassword()
            }
            .bind(to: passwowordValid)
            .disposed(by: disposeBag)
        
        //각 텍스트필드 유효성 묶음
        Observable.combineLatest(emailValid, passwowordValid)
            .map { emailValid, passwowordValid in
                return [emailValid, passwowordValid]
            }
            .bind(to: validationArray)
            .disposed(by: disposeBag)
        
        let logInData = Observable.combineLatest(input.email, input.password)
        
        input.logInButtonClicked
            .withLatestFrom(validationArray)
            .filter {
                return $0.allSatisfy { $0 == true }
            }
            .withLatestFrom(logInData)
            .flatMap { email, passwrd in
                APIManager.shared.singleRequest(type: LogInResponse.self, api: .logIn(model: LogInRequest(email: email, password: passwrd, deviceToken: "")))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                    KeychainManager.shared.create(account: "token", value: response.token.accessToken)
                    KeychainManager.shared.create(account: "token", value: response.token.refreshToken)

                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(logInButtonActive: logInButtonActive, validationArray: validationArray)
    }
}
