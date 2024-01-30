//
//  WorkspaceInitalViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/30.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkspaceInitalViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let addWorkspaceButtonClicked: ControlEvent<Void>
        let dismissButtonClicked: ControlEvent<Void>
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        input.dismissButtonClicked
            .flatMap {
                APIManager.shared.singleRequest(type: Workspaces.self, api: .getWorkspaceList)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("WorkspaceInitial Get Workspace Success", response)
                    if response.count > 0 {
                        SwitchView.shared.switchView(viewController: TabBarController())
                    } else {
                        SwitchView.shared.switchView(viewController: HomeViewController(homeState: .empty))
                    }
                case .failure(let error):
                    print("WorkspaceInitial Get Workspace Failure", error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
