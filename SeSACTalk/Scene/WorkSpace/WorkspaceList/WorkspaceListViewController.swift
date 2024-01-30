//
//  WorkspaceListViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/26.
//

import UIKit

class WorkspaceListViewController: BaseViewController {
    
    let homeState: HomeState
    
    let topView = {
        let view = UIView()
        view.backgroundColor = Colors.BackgroundColor.primary
        return view
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.text = "워크스페이스"
        label.textColor = Colors.TextColor.primary
        label.font = .systemFont(ofSize: Typography.Title1.size, weight: Typography.Title1.weight)
        return label
    }()
    
    let emptyListView = EmptyListView()
    
    let addWorkspaceButton = LeftImageButton(title: "워크스페이스 추가", imageName: "plus")
    
    let helpButton = LeftImageButton(title: "도움말", imageName: "questionmark.circle")
    
    init(homeState: HomeState) {
        self.homeState = homeState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    
    override func configureView() {
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = Colors.BackgroundColor.secondary
    
        [topView, titleLabel, addWorkspaceButton, helpButton].forEach {
            view.addSubview($0)
        }
        
        switch homeState {
        case .empty:
            [emptyListView].forEach {
                view.addSubview($0)
            }
            
        case .nonempty:
            print("otl")
        }
        
    }
    
    override func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(topView.snp.bottom).offset(-17)
        }
        
        helpButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(41)
        }
        
        addWorkspaceButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(41)
            make.bottom.equalTo(helpButton.snp.top)
        }
        
        switch homeState {
        case .empty:
            emptyListView.snp.makeConstraints { make in
                make.top.equalTo(topView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(addWorkspaceButton.snp.top)
            }
        
        case .nonempty:
            print("otl")
        }
    }
}
