//
//  SIdeMenuNavigation.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/26.
//

import UIKit
import SideMenu

class SideMenuNavigation: SideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationStyle = .menuSlideIn
        
        self.leftSide = true
        
        self.statusBarEndAlpha = 0
        
        self.presentDuration = 0.5
        
        self.dismissDuration = 0.5
        
        self.menuWidth = view.frame.width * 0.8
        
        self.dismissWhenBackgrounded = true
        
//        self.presentationStyle.backgroundColor = .blue
        self.presentationStyle.presentingEndAlpha = 0.4
//        self.presentationStyle.onTopShadowOpacity = 0.8
    }
}
