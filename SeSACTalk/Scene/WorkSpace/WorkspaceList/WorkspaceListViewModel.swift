//
//  WorkspaceListViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/01.
//

import Foundation
import RxSwift
import RxCocoa

class WorkspaceListViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    let enterFlag = BehaviorSubject(value: false)
    
    struct Input {
        let homeState: BehaviorSubject<HomeState>
    }
    
    struct Output {
        let workspaceList: BehaviorSubject<Workspaces>
    }
    
    func transform(input: Input) -> Output {
        
        let workspaceList: BehaviorSubject<Workspaces> = BehaviorSubject(value: [])
        
        Observable.combineLatest(input.homeState, enterFlag)
            .filter { homeState, enterFlag in
                homeState == .nonempty && enterFlag == true
            }
            .flatMapLatest { _ in
                APIManager.shared.singleRequest(type: Workspaces.self, api: .getWorkspaceList)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("HomeView Get WorkspaceList Success",response)
                    workspaceList.onNext(response)
                case .failure(let error):
                    print("HomeView Get WorkspaceList Failure",error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(workspaceList: workspaceList)
    }
}
