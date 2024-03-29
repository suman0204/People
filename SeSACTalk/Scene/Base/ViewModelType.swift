//
//  ViewModelType.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/04.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
