//
//  EmptyView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/24.
//

import UIKit

final class EmptyView: BaseView {
    
    let titleLabel = {
        let label = UILabel()
        label.text = "워크스페이스를 찾을 수 없어요."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Typography.Title1.size, weight: Typography.Title1.weight)
        label.textColor = Colors.BrandColor.black
        return label
    }()
    
    let bodyLabel = {
        let label = UILabel()
        label.text = "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나 \n 새로운 워크스페이스를 생성해주세요."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.textColor = Colors.BrandColor.black
        return label
    }()
    
    let emptyspaceImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "workspace empty")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let addWorkspaceButton = CustomButton(title: "워크스페이스 생성", setbackgroundColor: Colors.BrandColor.green)
    
    override func configureView() {
        self.backgroundColor = Colors.BackgroundColor.secondary
        
        [titleLabel, bodyLabel, emptyspaceImage, addWorkspaceButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(35)
            make.height.equalTo(30)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }
        
        emptyspaceImage.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(emptyspaceImage.snp.width)
        }
        
        addWorkspaceButton.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(emptyspaceImage.snp.bottom).offset(153)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
