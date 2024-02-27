//
//  ChannelInfoTable.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/27.
//

import Foundation
import RealmSwift

class ChannelInfoTable: Object {
    @Persisted(primaryKey: true) var channelID: Int
    @Persisted var channelName: String
    
    @Persisted var chat: List<ChatTable>
    
    convenience init(channelID: Int, channelName: String) {
        self.init()
        self.channelID = channelID
        self.channelName = channelName
    }
}
