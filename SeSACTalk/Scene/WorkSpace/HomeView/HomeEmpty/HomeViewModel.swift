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
    
    let workspaceID = KeychainManager.shared.read(account: .workspaceID) ?? "0"
    
    //NotificationCenter
    let changeWorkspaceNoti = NotificationCenter.default.rx.notification(Notification.Name("ChangeWorkspace"))
    
    struct Input {
        let homeState: BehaviorSubject<HomeState>
    }
    
    struct Output {
//        let profileData
        let workspaceList: BehaviorSubject<Workspaces>
        let workspace: BehaviorSubject<Workspace>
    }
    
    func transform(input: Input) -> Output {
        let workspaceList: BehaviorSubject<Workspaces> = BehaviorSubject(value: [])
        let workspace: BehaviorSubject<Workspace> = BehaviorSubject(value: Workspace(workspaceID: 0, name: "", description: "", thumbnail: "", ownerID: 0, createdAt: "", channels: [], workspaceMembers: []))
        
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
        
        guard let workspaceID = KeychainManager.shared.read(account: .workspaceID), let intID = Int(workspaceID) else {
            print("WorkspaceID Nil")
            return Output(workspaceList: workspaceList, workspace: workspace)
        }
        
        Observable.combineLatest(input.homeState, enterFlag)
            .filter { homeState, enterFlag in
                homeState == .nonempty && enterFlag == true
            }
            .flatMapLatest { _ in
                APIManager.shared.singleRequest(type: Workspace.self, api: .getOneWorkspace(id: intID))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("HomeView Get Workspace Info Success", response)
                    workspace.onNext(response)
                case .failure(let error):
                    print("HomeView Get Workspace Info Failure", error)
                    
                }
            }
            .disposed(by: disposeBag)
        
        changeWorkspaceNoti
            .flatMapLatest { noti in
                APIManager.shared.singleRequest(type: Workspace.self, api: .getOneWorkspace(id: noti.object as! Int))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("HomeView Get Workspace Info Success", response)
                    workspace.onNext(response)
                case .failure(let error):
                    print("HomeView Get Workspace Info Failure", error)
                    
                }
            }
            .disposed(by: disposeBag)
        
//        input.homeState
//            .map {
//                if $0 == HomeState.nonempty {
//                    return true
//                } else {
//                    return false
//                }
//            }
            
        
//        enterFlag
//            .map {
//                if input.homeState == HomeState.empty {
//                    return false
//                }
//            }
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
        
        return Output(workspaceList: workspaceList, workspace: workspace)
    }
}
