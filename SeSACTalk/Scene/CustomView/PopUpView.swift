//
//  PopUpView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/05.
//

import UIKit

enum ButtonType {
    case single
    case double
}

final class PopUpView: BaseViewController {
    
//    private let titleText: String
//    
//    private let bodyText: String
    
    private let buttonTitle: String
    
    private let buttonType: ButtonType
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        label.textColor = Colors.TextColor.primary
        label.textAlignment = .center
        return label
    }()
    
    private let bodyLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.textColor = Colors.TextColor.secondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var greenButton = CustomButton(title: buttonTitle , setbackgroundColor: Colors.BrandColor.green)
    
    private let cancelButton = CustomButton(title: "취소", setbackgroundColor: Colors.BrandColor.inactive)
    
    private let containerView = {
        let view = UIView()
        view.backgroundColor = Colors.BackgroundColor.secondary
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
        
    init(titleText: String, bodyText: String, buttonTitle: String, buttonType: ButtonType) {
        self.titleLabel.text = titleText
        self.bodyLabel.text = bodyText
        self.buttonTitle = buttonTitle
        self.buttonType = buttonType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        
        view.backgroundColor = UIColor(named: "ViewAlpha")
        
        switch buttonType {
        case .single:
            self.cancelButton.isHidden = true
        case .double:
            self.cancelButton.isHidden = false
        }
        
        [cancelButton, greenButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [titleLabel, bodyLabel, buttonStackView].forEach {
            containerView.addSubview($0)
        }

        view.addSubview(containerView)
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16.5)
            make.height.equalTo(20)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16.5)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    
}