//
//  DMTableViewCell.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/20.
//

import UIKit
import RxSwift

class DmTableViewCell: BaseTableViewCell {
    
    private var disposeBag = DisposeBag()
    
    private let profileImage = {
        let imageView = UIImageView(frame: .zero)
//        imageView.image = UIImage(named: "hashtag")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.numberOfLines = 1
        return label
    }()
    
    //24 18 caption
    private let unreadCount = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Caption.size, weight: Typography.Caption.weight)
        label.textColor = Colors.BrandColor.white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureCell() {
        [profileImage, nameLabel, unreadCount].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17.8)
//            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            
        }
        
        unreadCount.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-17)
            make.centerY.equalToSuperview()
        }
    }

}
