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
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if let date = isoDateFormatter.date(from: createdAt) {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
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
struct Workspace: Decodable {
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
struct Channel: Decodable, Equatable {
    let workspaceID, channelID: Int
    let name: String
    let description: String?
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
// MARK: - Channels
typealias Channels = [Channel]

// MARK: - WorkspaceMember
struct WorkspaceMember: Decodable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}

typealias WorkspaceMembers = [WorkspaceMember]

// MARK: - DM
struct DM: Decodable {
    let workspaceID, roomID: Int
    let createdAt: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case roomID = "room_id"
        case createdAt, user
    }
}

// MARK: - DMs
typealias DMs = [DM?]

// MARK: - User
struct User: Decodable {
    let userID: Int
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}

// MARK: - ChannelChatting
struct ChannelChatting: Decodable {
    let channelID: Int
    let channelName: String
    let chatID: Int
    let content: String
    let createdAt: String
    let files: [String?]
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case chatID = "chat_id"
        case channelName, content, createdAt, files, user
    }
}
// MARK: - ChannelChattings
typealias ChannelChattings = [ChannelChatting]

// MARK: - PayValid
struct PayValid: Decodable {
    let billing_id: Int
    let merchant_uid: String
    let amount: Int
    let sesacCoin: Int
    let success: Bool
    let createdAt: String
}
