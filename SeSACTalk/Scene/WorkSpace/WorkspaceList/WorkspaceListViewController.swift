//
//  WorkspaceListViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/26.
//

import UIKit

class WorkspaceListViewController: BaseViewController {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    
    override func configureView() {
        self.navigationController?.navigationBar.isHidden = true
    
        topView.addSubview(titleLabel)
        
        [topView, emptyListView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-17)
        }
        
        emptyListView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
