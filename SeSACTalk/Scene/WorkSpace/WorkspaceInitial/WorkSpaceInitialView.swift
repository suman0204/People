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
    
    let disposeBag = DisposeBag()
    let viewModel = WorkspaceInitalViewModel()
    
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
        label.text = "Entrance님의 조직을 위해 새로운 People의 워크스페이스를 시작할 준비가 완료되었어요!"
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
    
    lazy var createWorkspaceButton = {
        let button = CustomButton(title: "워크스페이스 생성", setbackgroundColor: Colors.BrandColor.green)
        button.addTarget(self, action: #selector(createWorkspaceButtonClicked), for: .touchUpInside)
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
        
//        "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOTQsIm5pY2tuYW1lIjoiMDIwNDAyMDUiLCJpYXQiOjE3MDUzMDc3NDEsImV4cCI6MTcwNTMxMTM0MSwiaXNzIjoic2xwIn0.-jT_3xOpPOc8KeSWw1C3YG2nIxnXzFRUjNy0xnsCcQM",
//        "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOTQsImlhdCI6MTcwNTMwNzc0MSwiZXhwIjoxNzA1Mzc5NzQxLCJpc3MiOiJzbHAifQ.oguhUsKZ9SMjIIW_7DTYuHj5qFpi9A0nFZVUETV9eIQ"
//    }
        
//        KeychainManager.shared.create(account: "accessToken", value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOTQsIm5pY2tuYW1lIjoiMDIwNDAyMDUiLCJpYXQiOjE3MDUzMDc3NDEsImV4cCI6MTcwNTMxMTM0MSwiaXNzIjoic2xwIn0.-jT_3xOpPOc8KeSWw1C3YG2nIxnXzFRUjNy0xnsCcQM")
//        KeychainManager.shared.create(account: "refreshToken", value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOTQsImlhdCI6MTcwNTMwNzc0MSwiZXhwIjoxNzA1Mzc5NzQxLCJpc3MiOiJzbHAifQ.oguhUsKZ9SMjIIW_7DTYuHj5qFpi9A0nFZVUETV9eIQ")
    }
    
    override func bind() {
        let input = WorkspaceInitalViewModel.Input(addWorkspaceButtonClicked: createWorkspaceButton.rx.tap, dismissButtonClicked: dismissButton.rx.tap)
        
//        let output = viewModel.transform(input: input)
        
        
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
//        APIManager.shared.request(type: Workspaces, api: .getWorkspaceList) { result in
//            switch result {
//            case .success(let response):
//                if response.count > 0 {
//                    
//                } else {
//                    
//                }
//            case .failure(let error):
//                <#code#>
//            }
//        }
    }
    
    @objc
    func createWorkspaceButtonClicked() {
        let vc = AddWorkspaceViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [
                .large()
            ]
            
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
}
