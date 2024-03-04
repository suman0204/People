//
//  ChannelHeaderView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/25.
//

import UIKit

class ChannelHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel = {
        let label = UILabel()
        label.text = "채널"
        label.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        return label
    }()
    
    let chevronImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "ChevronDown")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
//        contentView.backgroundColor = .yellow
//        contentView.snp.makeConstraints { make in
//            make.height.equalTo(56)
//        }
        [titleLabel, chevronImage].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        chevronImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
