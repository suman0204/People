//
//  SignUpState.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/15.
//

import Foundation

enum EmailValidationState {
    case isValid
    case inValid
    
    var description: String {
        switch self {
        case .isValid:
            return "사용 가능한 이메일입니다."
        case .inValid:
            return "중복된 이메일입니다."
        }
    }
}

enum SignUpState: Int {
    case emailValid = 0
    case nicknameValid = 1
    case phoneNumberValid = 2
    case passwordValid = 3
    case checkPasswordValid = 4
    case existed
    case error
    
    var description: String {
        switch self {
        case .emailValid:
            return "이메일 중복 확인을 진행해주세요."
        case .nicknameValid:
            return "닉네임은 1글자 이상 30글자 이내로 부탁드려요."
        case .phoneNumberValid:
            return "잘못된 전화번호 형식입니다."
        case .passwordValid:
            return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
        case .checkPasswordValid:
            return "작성하신 비밀번호가 일치하지 않습니다."
        case .existed:
            return "이미 가입된 회원입니다. 로그인을 진행해주세요."
        case .error:
            return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
        }
    }
}

enum LogInState: Int {
    case emailValid = 0
    case passwordValid = 1
    
    var description: String {
        switch self {
        case .emailValid:
            return "이메일 형식이 올바르지 않습니다."
        case .passwordValid:
            return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
        }
    }
}

enum AddWorkspaceState: Int {
    case imageValid = 0
    case nameValid = 1
    
    var description: String {
        switch self {
        case .imageValid:
            return "워크스페이스 이미지를 등록해주세요"
        case .nameValid:
            return "워크스페이스 이름은 1~30자로 설정해주세요"
        }
    }
}
