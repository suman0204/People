//
//  ChatTable.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/27.
//

import Foundation
import RealmSwift

class ChatTable: Object {
    @Persisted(primaryKey: true) var chatID: Int
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    
    @Persisted var user: List<UserInfoTable>
    
    @Persisted(originProperty: "chat") var channel: LinkingObjects<ChannelInfoTable>
    
    convenience init(chatID: Int, content: String, createdAt: String, files: List<String>) {
        self.init()
        self.chatID = chatID
        self.content = content
        self.createdAt = createdAt
        self.files = files
    }
}
