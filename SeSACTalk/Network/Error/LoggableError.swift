//
//  LoggableError.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/12.
//

import Foundation

protocol LoggableError: Error {
    var rawValue: String { get }
    var description: String { get }
}
