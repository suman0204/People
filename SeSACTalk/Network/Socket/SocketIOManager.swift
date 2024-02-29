//
//  SocketIOManager.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/28.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager = SocketManager(socketURL: URL(string: APIKey.baseURL)!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        
        socket = manager.defaultSocket
        print(#function)
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Sokcet is connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED : ", data, ack)
        }
        
        socket.on(clientEvent: .ping) { data, ack in
            print("ping")
        }
    }
    
    func connectSocket(channelID: Int) {
        let nameSpace = "/ws-channel-\(channelID)"
        
        socket = self.manager.socket(forNamespace: nameSpace)
        socket.connect()

    }
    
    func receiveChattingData(completion: @escaping (ChannelChatting) -> Void) {
        socket.on("channel") { data, ack in
            print("Channel Received", data, ack)
            
            guard let data = data.first else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let chatData = try JSONDecoder().decode(ChannelChatting.self, from: jsonData)
                
                print("ChatData", chatData)
                completion(chatData)
            } catch {
                print("Decoding Error ", error)
            }
        }
    }
    
    func disconnectSocket() {
        
        socket.disconnect()
        socket.removeAllHandlers()

    }
}
