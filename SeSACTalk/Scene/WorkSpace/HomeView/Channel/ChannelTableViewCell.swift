//
//  ChannelTableViewCell.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/25.
//

import UIKit
import RxSwift

class ChannelTableViewCell: BaseTableViewCell {
    
    private var disposeBag = DisposeBag()
    
    private let hashtagImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "hashtag")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.textColor = Colors.TextColor.primary
        label.numberOfLines = 1
        return label
    }()
    
    //24 18 caption
    private let unreadCount = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.BodyBlod.size, weight: Typography.BodyBlod.weight)
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
    
    
    func setData(data: Channel) {
        titleLabel.text = data.name
    }
}
