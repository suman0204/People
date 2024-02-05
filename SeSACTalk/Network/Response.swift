//
//  Response.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/11.
//

import Foundation

// MARK: - Error
struct ErrorResponse: Decodable {
    let errorCode: String
}

// MARK: - Sign Up
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

// MARK: - Token
struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}

// MARK: - Log In
struct LogInResponse: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String
    let token: Token
}

// MARK: - Refresh
struct RefreshResponse: Decodable {
    let accessToken: String
}

// MARK: - Add Workspace
struct AddWorkspaceResponse: Decodable {
    let workspaceID, ownerID: Int
    let description: String?
    let name, thumbnail, createdAt: String
//    let createdAt: Date
    
    var formattedCreatedAt: String {
        let dataFormmater = DateFormatter()
        dataFormmater.dateFormat = "yyyy.MM.dd"
        let date = dataFormmater.date(from: createdAt)
        let dataString = dataFormmater.string(from: date ?? Date())
        return dataString
    }
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case ownerID = "owner_id"
        case name,description, thumbnail, createdAt
    }
}

// MARK: - Workspaces
typealias Workspaces = [AddWorkspaceResponse]

// MARK: - MyProfile
struct MyProfile: Decodable {
    let userID, email, nickname, createdAt: String
    let profileImage, phone, vendor: String?
    let sesacCoin: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, createdAt, profileImage, phone, vendor, sesacCoin
    }
}

// MARK: - Workspace (One)
struct Workspace: Codable {
    let workspaceID: Int
    let name, description, thumbnail: String
    let ownerID: Int
    let createdAt: String
    let channels: [Channel]
    let workspaceMembers: [WorkspaceMember]

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name, description, thumbnail
        case ownerID = "owner_id"
        case createdAt, channels, workspaceMembers
    }
}

// MARK: - Channel
struct Channel: Codable {
    let workspaceID, channelID: Int
    let name, description: String
    let ownerID, channelPrivate: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case channelID = "channel_id"
        case name, description
        case ownerID = "owner_id"
        case channelPrivate = "private"
        case createdAt
    }
}

// MARK: - WorkspaceMember
struct WorkspaceMember: Codable {
    let userID: Int
    let email, nickname, profileImage: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
