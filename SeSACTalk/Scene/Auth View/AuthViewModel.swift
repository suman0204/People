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

class AuthViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let kakaoLoginButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        input.kakaoLoginButtonClicked
        
        return Output()
    }
}
