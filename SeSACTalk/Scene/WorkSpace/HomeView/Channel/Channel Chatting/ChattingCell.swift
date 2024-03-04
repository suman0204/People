////
////  ChattingCell.swift
////  SeSACTalk
////
////  Created by 홍수만 on 2024/02/22.
////
//
//import UIKit
//import RxSwift
//
//class ChattingCell: BaseTableViewCell {
//    
//    var disposeBag = DisposeBag()
//    
////    let wholeStackView = {
////        let stackView = UIStackView()
////        stackView.axis = .horizontal
////        stackView.alignment = .fill
////        stackView.distribution = .fillProportionally
////        stackView.spacing = 8
////        stackView.backgroundColor = .blue
////        return stackView
////    }()
//    
//    let middleStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.distribution = .fillProportionally
//        stackView.spacing = 5
//        stackView.backgroundColor = .yellow
//        return stackView
//    }()
//    
//    
//    let profileImage = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 8
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//    
//    let nameLabel = {
//        let label = UILabel()
//        label.numberOfLines = 1
//        label.font = .systemFont(ofSize: Typography.Caption.size, weight: Typography.Caption.weight)
//        label.textColor = Colors.BrandColor.black
//        label.backgroundColor = .red
//        return label
//    }()
//    
//    let chatTextLabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
//        label.textColor = Colors.BrandColor.black
//        label.text = "adfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjad"
//        return label
//    }()
//    
//    let chatBorderView = {
//        let view = UIView()
//        view.layer.borderColor = Colors.BrandColor.inactive.cgColor
//        view.layer.borderWidth = 1
//        view.layer.cornerRadius = 12
//        view.backgroundColor = .brown
//        return view
//    }()
//    
//    let imagesView = {
//        let view = UIView()
//        return view
//    }()
//    
//    let timeLabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.font = .systemFont(ofSize: Typography.Caption2.size, weight: Typography.Caption2.weight)
//        label.textColor = Colors.TextColor.secondary
//        return label
//    }()
//    
//    override func prepareForReuse() {
//        disposeBag = DisposeBag()
//        
////        profileImage.image = nil
////        nameLabel.text = nil
////        chatTextLabel.text = nil
////        timeLabel.text = nil
//        
//    }
//    
//    override func configureCell() {
//        
//        [chatTextLabel].forEach {
//            chatBorderView.addSubview($0)
//        }
//        
//        [profileImage, chatBorderView, timeLabel].forEach {
//            contentView.addSubview($0)
//        }
//        
////        [nameLabel, chatBorderView/*, imagesView*/].forEach {
////            middleStackView.addArrangedSubview($0)
////        }
////        
////        [profileImage, middleStackView, timeLabel].forEach {
////            contentView.addSubview($0)
////        }
////        
////        [wholeStackView].forEach {
////            contentView.addSubview($0)
////        }
//    }
//    
//    override func setConstraints() {
//        profileImage.snp.makeConstraints { make in
//            make.size.equalTo(34)
//            make.top.equalToSuperview().offset(6)
//            make.leading.equalToSuperview()
//        }
////        
////        middleStackView.snp.makeConstraints { make in
////            make.top.equalTo(profileImage.snp.top)
////            make.leading.equalTo(profileImage.snp.trailing).offset(5)
////            make.height.greaterThanOrEqualTo(34)
////        }
////        
////        nameLabel.snp.makeConstraints { make in
////            
////        }
////        
////        chatBorderView.snp.makeConstraints { make in
////            make.height.greaterThanOrEqualTo(34)
////        }
////        
////        timeLabel.snp.makeConstraints { make in
////            make.bottom.equalToSuperview().offset(-6)
////            make.leading.equalTo(middleStackView.snp.trailing).offset(5)
////            make.trailing.lessThanOrEqualToSuperview().offset(-14)
////        }
////        wholeStackView.snp.makeConstraints { make in
////            make.horizontalEdges.equalToSuperview().inset(16)
////            make.verticalEdges.equalToSuperview()
////        }
////        
////        profileImage.snp.makeConstraints { make in
////            make.size.equalTo(34)
////            make.top.equalToSuperview().offset(6)
////            make.leading.equalToSuperview()
//////            make.trailing.greaterThanOrEqualToSuperview().offset(-343)
////        }
////        
////        middleStackView.setContentHuggingPriority(.init(750), for: .horizontal)
////        middleStackView.snp.makeConstraints { make in
//////            make.verticalEdges.equalTo(contentView).inset(6)
////            make.height.greaterThanOrEqualTo(34)
////        }
////        
////        nameLabel.snp.makeConstraints { make in
////            make.size.equalTo(34)
////            make.top.equalToSuperview()
////            make.horizontalEdges.equalToSuperview()
////        }
//        
////        chatBorderView.snp.makeConstraints { make in
////            make.horizontalEdges.equalToSuperview()
////        }
//        nameLabel.snp.makeConstraints { make in
//            make.top.equalTo(profileImage.snp.top)
//            make.leading.equalTo(profileImage.snp.trailing).offset(8)
//        }
//        
//        chatBorderView.snp.makeConstraints { make in
//            make.leading.equalTo(nameLabel.snp.leading)
//            make.top.equalTo(nameLabel.snp.bottom).offset(5)
//            make.trailing.lessThanOrEqualToSuperview().offset(-91)
//            make.bottom.equalToSuperview().offset(-6)
//        }
////        
////        chatTextLabel.snp.makeConstraints { make in
////            make.edges.equalToSuperview().inset(10)
////        }
////        
////        timeLabel.setContentHuggingPriority(.init(751), for: .horizontal)
//        timeLabel.snp.makeConstraints { make in
//            make.leading.equalTo(chatBorderView.snp.trailing).offset(8)
//            make.bottom.equalToSuperview().offset(-6)
//            make.trailing.lessThanOrEqualToSuperview().offset(-14)
////            make.width.equalTo(56)
//        }
//    }
//    
//}
// 

//
//  ChattingCell.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/22.
//

import UIKit
import RxSwift

class ChattingCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    
    let profileImage = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: Typography.Caption.size, weight: Typography.Caption.weight)
        label.textColor = Colors.BrandColor.black
        return label
    }()
    
    let chatTextLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.textColor = Colors.BrandColor.black
        return label
    }()
    
    let chatBorderView = {
        let view = UIView()
        view.layer.borderColor = Colors.BrandColor.inactive.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    let imagesView = {
        let view = UIView()
        return view
    }()
    
    let timeLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Typography.Caption2.size, weight: Typography.Caption2.weight)
        label.textColor = Colors.TextColor.secondary
        return label
    }()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        
        profileImage.image = nil
        nameLabel.text = nil
        chatTextLabel.text = nil
        timeLabel.text = nil
        
    }
    
    override func configureCell() {
        
        [chatTextLabel].forEach {
            chatBorderView.addSubview($0)
        }
        
        [profileImage, nameLabel, chatBorderView, imagesView, timeLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(34)
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(16)
//            make.bottom.lessThanOrEqualTo(contentView.snp.bottom)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(18)
        }
        
        chatBorderView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.trailing.lessThanOrEqualToSuperview().offset(-91)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        chatTextLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(chatBorderView.snp.trailing).offset(8)
            make.bottom.equalTo(chatBorderView.snp.bottom)
            make.trailing.lessThanOrEqualToSuperview().offset(-30)
            make.width.equalTo(53)
        }
    }
    
}
 
