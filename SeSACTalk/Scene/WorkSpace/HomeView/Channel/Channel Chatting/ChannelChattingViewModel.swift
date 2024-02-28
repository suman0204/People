//
//  ChannelChattingViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/25.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ChannelChattingViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    let imageData: BehaviorSubject<[Data]> = BehaviorSubject(value: [])
    
    let enterFlag = BehaviorSubject(value: false)
    
//    let cursorDate: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    //Realm
    private let repository = ChannelChatRepository()
    private var tasks: Results<ChannelInfoTable>!
    
    struct Input {
        let textInput: ControlProperty<String>
//        let imageCount: BehaviorSubject<Int>
//        let selectedImageData: BehaviorSubject<[Data]>
        let sendButtonClicekd: ControlEvent<Void>
    }
    
    struct Output {
        let sendButtonEnabled: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        var cursorDate: String = ""
        let workspaceID = Int(KeychainManager.shared.read(account: .workspaceID) ?? "0") ?? 0
        let channelName = KeychainManager.shared.read(account: .channelName) ?? ""
        let channelID = Int(KeychainManager.shared.read(account: .channelID) ?? "0") ?? 0
        
        let sendButtonEnabled = BehaviorRelay(value: false)
        
        let inputData = Observable.combineLatest(input.textInput, imageData)
        
        //Enter View
        enterFlag
            .filter {
                $0 == true
            }
            .do { [unowned self] _ in                
                //Realm 데이터 불러오기
                self.tasks = self.repository.fetchChannelTable(channelID: channelID)
                print("Chatting ViewModel tasks", self.tasks)

                if self.tasks.isEmpty {
                    print("0")
                    let channelInfoTable = ChannelInfoTable(channelID: channelID, channelName: channelName)
                    
                    repository.createChannelTable(channelInfoTable)
                    
                    cursorDate = dateToISO()
                }else {
                    print("not 0")
                    
                    cursorDate = tasks.first?.chat.last?.createdAt ?? dateToISO()
                }
            }
            .flatMapLatest({ _ in
                print(channelName)
                return APIManager.shared.singleRequest(type: ChannelChattings.self, api: .getChannelChattings(name: channelName, id: workspaceID, cursorDate: cursorDate))
            })
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let response):
                    print("GetChannelChatting Response", response)
                    if response.isEmpty {
                        print("No New Chat")
                    } else {
                        for newChat in response {
                            let chatTable = ChatTable(chatID: newChat.chatID, content: newChat.content, createdAt: newChat.createdAt, files: owner.filesToList(newChat.files))
                            
                            let userTable = UserInfoTable(userID: newChat.user.userID, email: newChat.user.email, nickname: newChat.user.nickname, profileImage: newChat.user.profileImage ?? "")
                            
                            owner.repository.createChatTable(chatTable, channelID: channelID)
                            owner.repository.createUserTable(userTable, chatID: newChat.chatID)
                        }
                    }
                case .failure(let error):
                    print("Get ChannelChattings Failure",error.rawValue)
                }
            })
            .disposed(by: disposeBag)
        
        //SendButton Enabled
        inputData
            .bind(with: self) { owner, value in
                if (value.0.count > 0 && value.0 != "메세지를 입력하세요") || value.1.count > 0 {
                    print("ChannelChattingViewModel true", value.1)
                    sendButtonEnabled.accept(true)
                } else {
                    print("ChannelChattingViewModel false", value.1)
                    sendButtonEnabled.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        inputData
            .bind(with: self) { owner, value in
                print("Channel Chatting Value", value)
            }
            .disposed(by: disposeBag)
        
//        input.sendButtonClicekd
//            .withLatestFrom(inputData)
//            .flatMapLatest { inputData in
////                APIManager.shared.singleMultipartRequset(type: <#T##Decodable.Protocol#>, api: <#T##Router#>)
//            }
        
        return Output(sendButtonEnabled: sendButtonEnabled)
    }
}

extension ChannelChattingViewModel {
    func documentDirectoryPath() -> URL? {
        //1. 도큐먼트 폴더 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    func dateToISO() -> String {

        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        
        return dateFormatter.string(from: now)
    }
    
    func filesToList(_ files: [String?]) -> List<String> {
        let list = List<String>()
        
        for file in files {
            list.append(file ?? "")
        }
        
        return list
    }
}
