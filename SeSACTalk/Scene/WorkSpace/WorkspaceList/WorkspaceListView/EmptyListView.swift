//
//  EmptyListView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/26.
//

import UIKit

class EmptyListView: BaseView {
    
    let titleLabel = {
        let label = UILabel()
        label.text = "워크스페이스를 \n 찾을 수 없어요."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: Typography.Title1.size, weight: Typography.Title1.weight)
        return label
    }()
    
    let bodyLabel = {
        let label = UILabel()
        label.text = "관리자에게 초대를 요청하거나, \n 다른 이메일로 시도하거나 \n 새로운 워크스페이스를 생성해주세요."
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        return label
    }()
    
    let addWorkspaceButton = CustomButton(title: "워크스페이스 생성", setbackgroundColor: Colors.BrandColor.green)
    
    override func configureView() {
        
        self.backgroundColor = Colors.BackgroundColor.secondary
        
        [titleLabel, bodyLabel, addWorkspaceButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        bodyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        //183 258
        titleLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().offset(183)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(bodyLabel.snp.top).offset(-19)
        }
        
        addWorkspaceButton.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(19)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
}
