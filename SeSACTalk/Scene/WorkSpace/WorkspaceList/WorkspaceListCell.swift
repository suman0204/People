//
//  WorkspaceListCell.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/26.
//

import UIKit

class WorkspaceListCell: BaseTableViewCell {
    
    let workspaceImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let workspaceTitle = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.BodyBlod.size, weight: Typography.BodyBlod.weight)
        label.textColor = Colors.TextColor.primary
        label.numberOfLines = 1
        return label
    }()
    
    let workspaceCreatedAt = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.textColor = Colors.TextColor.secondary
        label.numberOfLines = 1
        return label
    }()
    
    let workspaceMenu = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "ellipsis")
        imageView.tintColor = Colors.BrandColor.black
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    let labelStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func configureCell() {
        
        [workspaceTitle, workspaceCreatedAt].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        [workspaceImage, labelStackView, workspaceMenu].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        workspaceImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            
        }
        
        workspaceMenu.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        
        //8, 18
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(workspaceImage.snp.trailing).offset(8)
            make.trailing.equalTo(workspaceMenu.snp.leading).offset(-18)
            make.centerY.equalToSuperview()
            make.height.equalTo(36)
        }
    }
}
