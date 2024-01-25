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
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
            let window = windowScene.windows.first else {
                return
        }
        
        window.rootViewController = UINavigationController(rootViewController: viewController)
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
