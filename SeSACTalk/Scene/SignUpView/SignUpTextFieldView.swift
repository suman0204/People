//
//  SignUpTextFieldView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/06.
//

import UIKit

enum SignUpViewType {
    case normal
    case withButton
}

class SignUpTextFieldView: UIView {
    
    init(type: SignUpViewType) {
        super.init(frame: .zero)
        self.type = type
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var type: SignUpViewType?
    
    //제목 레이블
    var labelText: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    //텍스트필드 플레이스홀더
    var placeholder: String? {
        get {
            return inputTextField.placeholder
        }
        set {
            inputTextField.placeholder = newValue
        }
    }
    
//    var viewType: SignUpViewType {
//        get {
//            return type
//        }
//        set {
//            type = newValue
//        }
//    }
//
//    init(type: SignUpViewType) {
//        super.init(frame: .zero)
//        self.type = type
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    let titleLabel = {
        let label = UILabel()
        label.textColor = Colors.BrandColor.black
        label.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        return label
    }()
    
    let inputTextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.backgroundColor = Colors.BackgroundColor.secondary
        textField.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        textField.addLeftPadding()
        return textField
    }()
    
    let validButton = {
        let button = CustomButton(title: "중복 확인", setbackgroundColor: Colors.BrandColor.inactive)
        return button
    }()
    
    func configureView() {
        guard let type = type else { return }
        print(type)
        switch type {
        case .normal:
            [titleLabel, inputTextField].forEach {
                addSubview($0)
            }

        case .withButton:
            [titleLabel, inputTextField, validButton].forEach {
                addSubview($0)
            }
        }
        
        setConstraints()
    }
    
    func setConstraints() {
        guard let type = type else { return }

        switch type {
        case .normal:
            titleLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.height.equalTo(24)
            }
            
            inputTextField.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(44)
            }
            
        case .withButton:
            titleLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.height.equalTo(24)
            }
            
            inputTextField.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.leading.equalToSuperview()
                make.width.lessThanOrEqualTo(233)
                make.height.equalTo(44)
            }
            
            validButton.snp.makeConstraints { make in
                make.leading.equalTo(inputTextField.snp.trailing).offset(12)
                make.width.lessThanOrEqualTo(100)
                make.trailing.equalToSuperview()
                make.centerY.equalTo(inputTextField)
                make.height.equalTo(44)
            }
        }
    }
}


