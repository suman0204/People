//
//  WorkSpaceInitialView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/16.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkSpaceInitialView: BaseViewController {
    
    let titleLabel = {
        let label = UILabel()
        label.text = "출시 준비 완료!"
        label.font = .systemFont(ofSize: Typography.Title1.size, weight: Typography.Title1.weight)
        label.textColor = Colors.BrandColor.black
        label.textAlignment = .center
        return label
    }()
    
    let bodyLabel = {
        let label = UILabel()
        label.text = "xxx님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!"
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.textColor = Colors.BrandColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let launchingImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "launching")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let createWorkspaceButton = {
        let button = CustomButton(title: "워크스페이스 생성", setbackgroundColor: Colors.BrandColor.green)
        return button
    }()
    
    //dismiss Button
    lazy var dismissButton = {
        let button = UIBarButtonItem(image: UIImage(named: "Xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        button.tintColor = Colors.BrandColor.black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BackgroundColor.primary
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundColor.secondary
        
        self.navigationItem.leftBarButtonItem = dismissButton
    
        self.title = "시작하기"
        
        [titleLabel, bodyLabel, launchingImage, createWorkspaceButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide).offset(10)
            make.top.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(35)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.lessThanOrEqualTo(30)
//            make.bottom.lessThanOrEqualTo(bodyLabel.snp.top).offset(-24)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.lessThanOrEqualTo(40)
            make.bottom.lessThanOrEqualTo(launchingImage.snp.top).offset(-15)
        }
        
        launchingImage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(launchingImage.snp.width)
            make.center.equalToSuperview()
        }
        
        createWorkspaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.top.lessThanOrEqualTo(launchingImage.snp.bottom).offset(153)
        }
    }
    
}

extension WorkSpaceInitialView {
    
    @objc
    func dismissButtonClicked() {
        self.dismiss(animated: true)
    }
}
