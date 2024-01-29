//
//  ChannelFooterView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/25.
//

import UIKit

class ChannelFooterView: UITableViewHeaderFooterView {
    
    let titleLabel = {
        let label = UILabel()
        label.text = "채널"
        label.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        return label
    }()
    
    let chevronImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "ChevronRight")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        [titleLabel, chevronImage].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
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
