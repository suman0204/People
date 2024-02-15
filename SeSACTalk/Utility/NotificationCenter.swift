//
//  NotificationCenterManager.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/14.
//

import Foundation
import RxSwift

//enum NotificationName {
//    
//}

//protocol NotificationCenterProtocol {
//    var name: Notification.Name { get }
//}
//
//extension NotificationCenterProtocol {
//    func addObserver() -> Observable<Any?> {
//        return NotificationCenter.default.rx.notification(self.name).map {
//            $0.object
//        }
//    }
//    
//    func post(object: Any? = nil) {
//        NotificationCenter.default.post(name: self.name, object: object, userInfo: nil)
//    }
//}
//final class NotificationCenterManager {
//    
//    static let shared = NotificationCenterManager()
//    
//    private let notificationCenter = NotificationCenter()
//    
//    private init() {
//        
//    }
//    
//    func addObserver() {
//        notificationCenter
//    }
//}
