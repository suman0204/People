//
//  ChannelChatRepository.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/27.
//

import Foundation
import RealmSwift

class ChannelChatRepository {
    
    private let realm = try! Realm()
    
    func fileURL() -> URL {
        print(realm.configuration.fileURL!)
        return realm.configuration.fileURL!
    }
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(fileURL())
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func fetchChannelTable(channelID: Int) -> Results<ChannelInfoTable> {
        let result = realm.objects(ChannelInfoTable.self).where {
            $0.channelID == channelID
        }
        
        return result
    }
    
    func createChannelTable(_ item: ChannelInfoTable) {
        print(fileURL())
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Create ChannelInfo Table Failure")
            print(error)
        }
    }
    
    func createChatTable(_ item: ChatTable, channelID: Int) {
        
        let channelTable = realm.objects(ChannelInfoTable.self).where {
            $0.channelID == channelID
        }.first!
        
        do {
            try realm.write {
                channelTable.chat.append(item)
            }
        } catch {
            print("Create Chat Table Failure")
            print(error)
        }
    }
    
    func createUserTable(_ item: UserInfoTable, chatID: Int) {
        
        let chatTable = realm.objects(ChatTable.self).where {
            $0.chatID == chatID
        }.first!
        // UserInfoTable에서 동일한 사용자를 찾습니다.
        let existingUser = realm.objects(UserInfoTable.self).filter("userID == %@", item.userID).first
        
        // 만약 동일한 사용자가 존재한다면 그대로 추가합니다.
        if let existingUser = existingUser {
            do {
                try realm.write {
                    chatTable.user.append(existingUser)
                }
            } catch {
                print("Failed to add user to ChatTable: \(error)")
            }
        } else {
            // 동일한 사용자가 존재하지 않으면 새로운 사용자를 추가합니다.
            do {
                try realm.write {
                    chatTable.user.append(item)
                }
            } catch {
                print("Create User Table Failure")
                print(error)
            }
        }
//        do {
//            try realm.write {
//                chatTable.user.append(item)
//            }
//        } catch {
//            print("Create User Table Failure")
//            print(error)
//        }
    }
}
