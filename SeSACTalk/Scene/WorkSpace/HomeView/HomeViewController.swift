//
//  HomeViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/18.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    let headerView = HomeHeaderView()
    
    let emptySpaceView = EmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bind() {
        
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        let headerViewTap = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
        headerView.addGestureRecognizer(headerViewTap)
        
        [headerView, emptySpaceView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        emptySpaceView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func headerViewTapped() {
        let workspaceList = WorkspaceListViewController()
        let menu = SideMenuNavigation(rootViewController: workspaceList)
        
        present(menu, animated: true)
    }
}
