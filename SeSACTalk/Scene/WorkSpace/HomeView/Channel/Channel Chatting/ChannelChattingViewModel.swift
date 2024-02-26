//
//  ChannelChattingViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/25.
//

import Foundation
import RxSwift
import RxCocoa

class ChannelChattingViewModel: ViewModelType {
    
    struct Input {
        let textInput: BehaviorSubject<String>
        let imageCount: BehaviorSubject<Int>
        let selectedImageData: BehaviorSubject<[Data]>
        let sendButtonClicekd: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
