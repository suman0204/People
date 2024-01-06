//
//  AuthViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxKakaoSDKUser
import KakaoSDKUser

final class AuthViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let kakaoLoginButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
//        let token: PublishSubject<OauthToken>
    }
    
    func transform(input: Input) -> Output {
        
        input.kakaoLoginButtonClicked
            .subscribe(with: self) { owner, _ in
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("loginWithKakaoTalk() success.")
                            
                            print(oauthToken)
                            
                            owner.getKakaoUserInfo()
                        }
                    }
                }
                
    
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    func getKakaoUserInfo() {
        UserApi.shared.me() { user,error in
            if let error = error {
                print(error)
            } else {
                print("me() success")
                
                print(user)
            }
        }
    }
}
