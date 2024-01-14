//
//  APIError.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/11.
//

import Foundation

enum CommonError: String, LoggableError {
    case accessValidation = "E01"
    case unknownRouter = "E97"
    case expiredAccessToekn = "E05"
    case authenticationFailed = "E02"
    case unknownAccount = "E03"
    case overCall = "E98"
    case unknownError 
    
    //Extra Error
    case validToken = "E04"
    case expiredRefreshToken = "E06"
    case wrongRequest = "E11"
    case duplicatedData = "E12"
    
    var description: String {
        switch self {
        case .accessValidation:
            return "SLP 접근권한"
        case .unknownRouter:
            return "알 수 없는 라우터 경로"
        case .expiredAccessToekn:
            return "액세스 토큰 만료"
        case .authenticationFailed:
            return "인증 실패"
        case .unknownAccount:
            return "알 수 없는 계정"
        case .overCall:
            return "과호출"
        default:
            return ""
        }
    }
    
}

enum RefreshError: String, LoggableError {
    case validToken = "E04"
    case unknownAccount = "E03"
    case expiredRefreshToken = "E06"
    case authenticationFailed = "E02"

    var description: String {
        switch self {
        case .validToken:
             return "유효한 토큰"
        case .unknownAccount:
            return "알수 없는 계정"
        case .expiredRefreshToken:
            return "리프레시토큰 만료"
        case .authenticationFailed:
            return "인증 실패"
        }
    }
}

enum SignUpError: String, LoggableError {
    case wrongRequest = "E11"
    case duplicatedData = "E12"
    
    var description: String {
        switch self {
        case .wrongRequest:
            return "잘못된 요청"
        case .duplicatedData:
            return "중복 데이터"
        }
    }
}

enum LoginError: String, LoggableError {
    case logInFalied = "E03"
    
    var description: String {
        switch self {
        case .logInFalied:
            return "로그인 실패"
        }
    }
}
