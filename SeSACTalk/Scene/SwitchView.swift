//
//  SwitchView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/24.
//

import UIKit

final class SwitchView {
    
    static let shared = SwitchView()
    
    private init() { }
    

    func switchView(viewController: UIViewController) {
//        guard let windowScene = UIApplication.shared.connectedScenes
//            .compactMap({ $0 as? UIWindowScene })
//            .first(where: { $0.activationState == .foregroundActive }),
//            let window = windowScene.windows.first else {
//            print("switch View fail")
//                return
//        }
        
        let sceneDelgate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        
        guard let delegate = sceneDelgate, let window = delegate.window else {
            return
        }
        
//        delegate.window?.rootViewController = UINavigationController(rootViewController: viewController)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            
        }

        
    }
}
