//
//  UserInfoTable.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/27.
//

import Foundation
import RealmSwift

class UserInfoTable: Object {
    @Persisted(primaryKey: true) var userID: Int
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String
    
    @Persisted(originProperty: "user") var chat: LinkingObjects<ChatTable>
    
    convenience init(userID: Int, email: String, nickname: String, profileImage: String) {
        self.init()
        
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
