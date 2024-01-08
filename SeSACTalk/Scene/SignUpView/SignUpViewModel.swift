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
    
    struct Input {
        let email: ControlProperty<String>
        let nickname: ControlProperty<String>
        let contact: ControlProperty<String>
        let password: ControlProperty<String>
        let checkPassword: ControlProperty<String>
        
        let validButtonClicked: ControlEvent<Void>
        let signUpButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let emailvalidation: BehaviorSubject<Bool>
//        let dic: BehaviorSubject<Dictionary>
        let signUpButtonActive: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let emailValidation = BehaviorSubject(value: false)
        let signUpButtonActive = BehaviorSubject(value: false)
        
        input.email
            .map {
                $0.count > 0
            }
            .bind(to: emailValidation)
            .disposed(by: disposeBag)
        
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
        
        return Output(emailvalidation: emailValidation, signUpButtonActive: signUpButtonActive)
    }
}
