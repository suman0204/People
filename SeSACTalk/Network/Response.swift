//
//  Response.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/11.
//

import Foundation

struct ErrorResponse: Decodable {
    let errorCode: String
}

struct SignUpResponse: Decodable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String
    let token: Token

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, vendor, createdAt, token
    }
}

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct LoginResponse: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String
    let token: Token
}
