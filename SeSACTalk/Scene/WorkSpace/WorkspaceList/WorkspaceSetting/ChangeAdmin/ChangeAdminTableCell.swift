//
//  ChangeAdminTableCell.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/14.
//

import UIKit
import RxSwift

final class ChangeAdminTableCell: BaseTableViewCell {

    private var disposeBag = DisposeBag()
    
    private let profieImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.BodyBlod.size, weight: Typography.BodyBlod.weight)
        label.textColor = Colors.TextColor.primary
        label.numberOfLines = 1
        return label
    }()
    
    private let emailLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.textColor = Colors.TextColor.secondary
        label.numberOfLines = 1
        return label
    }()
    
    private let labelStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureCell() {
        
        [nameLabel, emailLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        [profieImage, labelStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        profieImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(profieImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
            make.height.equalTo(36)
        }
    }
}

extension ChangeAdminTableCell {
    
    func setData(image: String, name: String, email: String) {
        profieImage.loadImage(from: image)
        nameLabel.text = name
        emailLabel.text = email
    }
}
