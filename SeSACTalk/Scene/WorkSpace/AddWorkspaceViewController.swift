//
//  AddWorkspaceViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/18.
//

import UIKit

final class AddWorkspaceViewController: BaseViewController {
    
    let selectImageButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "addworkspaceimage"), for: .normal)
        return button
    }()
    
    let workspaceNameTextField = {
        let view = CustomTextFieldView(type: .normal)
        view.labelText = "워크스페이스 이름"
        view.placeholder = "워크스페이스 이름을 입력하세요 (필수)"
        return view
    }()

    let workspaceDescriptionTextField = {
        let view = CustomTextFieldView(type: .normal)
        view.labelText = "워크스페이스 설명"
        view.placeholder = "워크스페이스를 설명하세요 (옵션)"
        return view
    }()
    
    let addWorkspaceButton = CustomButton(title: "완료", setbackgroundColor: Colors.BrandColor.inactive)
    
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
    
        self.title = "워크스페이스 생성"
        
        [selectImageButton, workspaceNameTextField, workspaceDescriptionTextField, addWorkspaceButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        selectImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        workspaceNameTextField.snp.makeConstraints { make in
            make.top.equalTo(selectImageButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
        }
        
        workspaceDescriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(workspaceNameTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
        }
        
        addWorkspaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
            make.top.lessThanOrEqualTo(workspaceDescriptionTextField.snp.bottom).offset(447)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
}


extension AddWorkspaceViewController {
    
    @objc
    func dismissButtonClicked() {
        self.dismiss(animated: true)
    }
}
