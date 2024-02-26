//
//  ChattingSelectedImageCell.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/25.
//

import UIKit

class ChattingSelectedImageCell: BaseCollectionViewCell {
    
    let imageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green
        return imageView
    }()
    
    let deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = Colors.BrandColor.black
        button.backgroundColor = .white
        button.clipsToBounds = true
        return button
    }()
    
    override func prepareForReuse() {
        
    }
    
    override func configureCell() {
        [imageView, deleteButton].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(-6)
            make.trailing.equalTo(imageView.snp.trailing).offset(6)
            make.size.equalToSuperview().multipliedBy(0.4)
        }
        
        deleteButton.layoutIfNeeded()
        deleteButton.layer.cornerRadius = deleteButton.bounds.width / 2
        deleteButton.clipsToBounds = true
    }
    
}
