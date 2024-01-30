//
//  TabBarController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/29.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTabBar()
    }
    
    func addTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController(homeState: .nonempty))
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        
        let dmVC = UINavigationController(rootViewController: UIViewController())
        dmVC.tabBarItem = UITabBarItem(title: "DM", image: UIImage(named: "dm"), selectedImage: UIImage(named: "dmSelected"))
        
        let searchVC = UINavigationController(rootViewController: UIViewController())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "search"), selectedImage: UIImage(named: "searchSelected"))
        
        let settingVC = UINavigationController(rootViewController: UIViewController())
        settingVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(named: "setting"), selectedImage: UIImage(named: "settingSelected"))
        
        self.viewControllers = [homeVC, dmVC, searchVC, settingVC]
    }
}
