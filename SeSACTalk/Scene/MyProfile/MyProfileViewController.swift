//
//  MyProfileViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/29.
//

import UIKit
import RxSwift
import RxCocoa

class MyProfileViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var profileImageView = {
        let imageView = UIImageView(frame: .zero)
//        imageView.image = UIImage(named: "workspace")
//        imageView.loadImage(from: workspaceInfo.thumbnail)
//        viewModel.image = imageView.image?.jpegData(compressionQuality: 0.5)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        print("Lazy", imageView.image)
        return imageView
    }()
    
    private let cameraImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "Camera")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let tableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = Colors.BackgroundColor.primary
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
    }
    
    override func configureView() {
        [profileImageView, cameraImageView, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView).offset(51)
            make.leading.equalTo(profileImageView).offset(53)
            make.size.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

//extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}

