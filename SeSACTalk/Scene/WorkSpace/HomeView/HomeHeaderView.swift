//
//  HomeHeaderView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/19.
//

import UIKit

final class HomeHeaderView: BaseView {
    
    let workspaceImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "workspace")
        imageView.backgroundColor = Colors.BrandColor.green
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let workspaceName = {
        let label = UILabel()
//        label.backgroundColor = .brown
        label.text = "No Workspace"
        label.textColor = Colors.TextColor.primary
        label.font = .systemFont(ofSize: Typography.Title1.size, weight: Typography.Title1.weight)
        return label
    }()
    
    lazy var profileImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 32/2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = Colors.BrandColor.black.cgColor
        return imageView
    }()
    
    override func configureView() {
        
//        backgroundColor = .yellow
//        self.layer.addBorder([.bottom], color: Colors.BrandColor.gray, width: 1)
        
        [workspaceImage, workspaceName, profileImage].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        workspaceImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(32)
//            make.bottom.lessThanOrEqualToSuperview().offset(-14)
        }
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(32)
//            make.bottom.lessThanOrEqualToSuperview().offset(-13)
        }
        
        workspaceName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(workspaceImage.snp.trailing).offset(8)
            make.trailing.equalTo(profileImage.snp.leading).offset(-12)
            make.verticalEdges.equalToSuperview()
        }
    }
}
