//
//  HomeEmptyViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/30.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    let enterFlag = BehaviorSubject(value: false)
    
    struct Input {
        let homeState: BehaviorSubject<HomeState>
    }
    
    struct Output {
//        let profileData
    }
    
    func transform(input: Input) -> Output {
        
//        enterFlag
//            .filter {
//                $0
//            }
//            .flatMapLatest {_ in 
//                input.homeState
//            }
//            .flatMapLatest { _ in
//                APIManager.shared.singleRequest(type: , api: .getWorkspaceList)
//            }
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case .success(let response):
//                    
//                case .failure(let error):
//                    
//                }
//            }
        
        return Output()
    }
}
