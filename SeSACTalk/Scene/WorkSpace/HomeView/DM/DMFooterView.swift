//
//  DMFooterView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/22.
//

import UIKit

class DMFooterView: UITableViewHeaderFooterView {
    
    let plusImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "plus")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let titleLabel = {
        let label = UILabel()
        label.text = "새 매시지 시작"
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.textColor = Colors.TextColor.secondary

        return label
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        [titleLabel, plusImage].forEach {
            contentView.addSubview($0)
        }
        
        plusImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17.8)
//            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(plusImage.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
