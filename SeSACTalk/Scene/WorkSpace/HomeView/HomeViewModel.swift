//
//  HomeEmptyViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/30.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

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
        let channels: BehaviorSubject<[Channel]>
        let sections: BehaviorRelay<[SectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let workspaceList: BehaviorSubject<Workspaces> = BehaviorSubject(value: [])
        let workspace: BehaviorSubject<Workspace> = BehaviorSubject(value: Workspace(workspaceID: 0, name: "", description: "", thumbnail: "", ownerID: 0, createdAt: "", channels: [], workspaceMembers: []))
        let channels: BehaviorSubject<[Channel]> = BehaviorSubject(value: [])
        let dms: BehaviorSubject<DMs> = BehaviorSubject(value: [])
        let sections: BehaviorRelay<[SectionModel]> = BehaviorRelay(value: [])
        
        // MARK: 화면 진입 시
        //화면 진입 상태
        let viewEnter = Observable.combineLatest(input.homeState, enterFlag)
        
        viewEnter
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
                    
//                    KeychainManager.shared.create(account: .workspaceID, value: String(response.first?.workspaceID ?? 0))
                case .failure(let error):
                    print("HomeView Get WorkspaceList Failure",error)
                }
            }
            .disposed(by: disposeBag)
        
//        if KeychainManager.shared.read(account: .workspaceID) == nil {
//            
//            KeychainManager.shared.create(account: .workspaceID, value: String(try! (workspaceList.value().first?.workspaceID ?? 0)))
//        } 
        
        guard let workspaceID = KeychainManager.shared.read(account: .workspaceID), let intID = Int(workspaceID) else {
            print("WorkspaceID Nil")
            return Output(workspaceList: workspaceList, workspace: workspace, channels: channels, sections: BehaviorRelay(value: []))
        }
        print("HomeView INT ID", intID)
        
        // Workspace 정보 조회
        viewEnter
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
//                    channels.onNext(response.channels)
                case .failure(let error):
                    print("HomeView Get Workspace Info Failure", error)
                    
                }
            }
            .disposed(by: disposeBag)
        
        //내가 속한 Channel 정보
        viewEnter
            .filter { homestate, enterFlag in
                homestate == .nonempty && enterFlag == true
            }
            .flatMapLatest { _ in
                APIManager.shared.singleRequest(type: Channels.self, api: .getMyChannels(id: intID))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("HomeView Get MyChannels Success", response)
                    channels.onNext(response)
                case .failure(let error):
                    print("HomeView Get MyChannels failure", error)
                }
            }
            .disposed(by: disposeBag)
        
        //나의 DM 정보
        viewEnter
            .filter { homestate, enterFlag in
                homestate == .nonempty && enterFlag == true
            }
            .flatMapLatest { _ in
                APIManager.shared.singleRequest(type: DMs.self, api: .getWorkspaceDMList(id: intID))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("HomeView Get DMs Success", response)
                    dms.onNext(response)
                case .failure(let error):
                    print("HomeView Get DMs failure", error)
                }
            }
            .disposed(by: disposeBag)
        
        //MARK: 워크스페이스 변경 시
        //워크스페이스 변경 시 워크스페이스 정보 리로드
        changeWorkspaceNoti
            .flatMapLatest { noti in
                APIManager.shared.singleRequest(type: Workspace.self, api: .getOneWorkspace(id: noti.object as! Int))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("HomeView Get Workspace Info Success", response)
                    workspace.onNext(response)
//                    channels.onNext(response.channels)
                case .failure(let error):
                    print("HomeView Get Workspace Info Failure", error)
                    
                }
            }
            .disposed(by: disposeBag)
        
        //워크스페이스 변경 시 내가 속한 Channel 정보 리로드
        changeWorkspaceNoti
            .flatMapLatest { noti in
                APIManager.shared.singleRequest(type: Channels.self, api: .getMyChannels(id: noti.object as! Int))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("HomeView Get MyChannels Success", response)
                    channels.onNext(response)
                case .failure(let error):
                    print("HomeView Get MyChannels failure", error)
                }
            }
            .disposed(by: disposeBag)
        
        changeWorkspaceNoti
            .flatMapLatest { noti in
                APIManager.shared.singleRequest(type: DMs.self, api: .getWorkspaceDMList(id: noti.object as! Int))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("HomeView Get DMs Success", response)
                    dms.onNext(response)
                case .failure(let error):
                    print("HomeView Get DMs failure", error)
                }
            }
            .disposed(by: disposeBag)

        
        Observable.combineLatest(channels, dms)
//            .subscribe(with: self, onNext: <#T##((Object, ([Channel], DMs)) -> Void)?##((Object, ([Channel], DMs)) -> Void)?##(Object, ([Channel], DMs)) -> Void#>)
            .subscribe(with: self) { owner, data in
                print("HomeViewModel Channels", channels)
                let masections: [SectionModel] = [.channelSection(header: ChannelHeaderView(), items: data.0.map { SectionItem.channelItem($0)}, footer: ChannelFooterView()),
                                                  .dmSection(header: ChannelHeaderView(), items: data.1.map {
                                                      SectionItem.dmItem($0 ?? DM(workspaceID: 0, roomID: 0, createdAt: "", user: User(userID: 0, email: "", nickname: "", profileImage: "")))
                                                  }, footer: ChannelFooterView()),
                                                  .addMemberSection(header: ChannelHeaderView())
                ]
                sections.accept(masections)
                print(masections)
            }
            .disposed(by: disposeBag)
        
        
        return Output(workspaceList: workspaceList, workspace: workspace, channels: channels, sections: sections)
    }
}
