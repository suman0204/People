//
//  Request.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/11.
//

import Foundation

struct EmailValidationRequest: Encodable {
    let email: String
}

struct SignUpRequest: Encodable {
    let email: String
    let nickname: String
    let phone: String?
    let password: String
    let deviceToken: String?
}

struct LogInRequest: Encodable {
    let email: String
    let password: String
    let deviceToken: String
}
