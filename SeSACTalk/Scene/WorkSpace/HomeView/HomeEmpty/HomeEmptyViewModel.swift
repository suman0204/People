//
//  HomeEmptyViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/30.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeEmptyViewModel: ViewModelType {
    
    let enterFlag = BehaviorSubject(value: false)
    
    struct Input {
        
    }
    
    struct Output {
//        let profileData
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
