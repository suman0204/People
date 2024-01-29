//
//  ChannelTableViewCell.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/25.
//

import UIKit

class ChannelTableViewCell: BaseTableViewCell {
    
    let hashtagImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "hashtag")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        return label
    }()
    
    //24 18 caption
    let unreadCount = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Caption.size, weight: Typography.Caption.weight)
        label.textColor = Colors.BrandColor.white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    override func configureCell() {
        [hashtagImage, titleLabel, unreadCount].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        hashtagImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17.8)
//            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(hashtagImage.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            
        }
        
        unreadCount.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-17)
            make.centerY.equalToSuperview()
        }
    }

}
