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
        
        let sendButtonEnabled = BehaviorRelay(value: false)
        
        let inputData = Observable.combineLatest(input.textInput, imageData)
        
        //Enter View
        enterFlag
            .filter {
                $0 == true
            }
            .do { [unowned self] _ in
//                print(self.documentDirectoryPath())
                self.tasks = self.repository.fetchChannelTable(channelID: Int(KeychainManager.shared.read(account: .channelID)!) ?? 0)
                print("Chatting ViewModel tasks", self.tasks)
                
                if self.tasks.isEmpty {
                    print("0")
                    let channelInfoTable = ChannelInfoTable(channelID: Int(KeychainManager.shared.read(account: .channelID)!) ?? 0, channelName: KeychainManager.shared.read(account: .channelName) ?? "")
                    repository.createChannelTable(channelInfoTable)
                    
                }else {
                    print("not 0")
                }
            }
            .flatMapLatest({ _ in
                APIManager.shared.singleRequest(type: <#T##Decodable.Protocol#>, api: <#T##Router#>)
            })
            .subscribe(with: self) { owner, _ in
                print("ChattingViewModel Flag")
            }
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
}
