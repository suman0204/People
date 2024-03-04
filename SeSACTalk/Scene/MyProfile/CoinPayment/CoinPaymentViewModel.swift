//
//  CoinPaymentViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/29.
//

import Foundation
import RxSwift
import RxCocoa

final class CoinPaymentViewModel: ViewModelType {
    
    lazy var cointData = CoinTableData(first: [CoinData(title: "🌱 현재 보유한 코인\(coin)", detail: "코인이란?", attribute: true, accessoryView: false)]
                                       ,second: [
                                        CoinData(title: "🌱 10 Coin", attribute: false, accessoryView: true, coinPrice: 100),
                                       CoinData(title: "🌱 50 Coin", attribute: false, accessoryView: true, coinPrice: 500),
                                       CoinData(title: "🌱 100 Coin", attribute: false, accessoryView: true, coinPrice: 1000)]
    )
    
    var coin: Int = 50
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
