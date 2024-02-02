//
//  WorkspaceListViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/26.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class WorkspaceListViewController: BaseViewController {
    
    let viewModel = WorkspaceListViewModel()
    let disposeBag = DisposeBag()
    
    let homeState: HomeState
    
    let topView = {
        let view = UIView()
        view.backgroundColor = Colors.BackgroundColor.primary
        return view
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.text = "워크스페이스"
        label.textColor = Colors.TextColor.primary
        label.font = .systemFont(ofSize: Typography.Title1.size, weight: Typography.Title1.weight)
        return label
    }()
    
    let emptyListView = EmptyListView()
    
    let tableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(WorkspaceListCell.self, forCellReuseIdentifier: WorkspaceListCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 72
        return tableView
    }()
    
    @objc let addWorkspaceButton = LeftImageButton(title: "워크스페이스 추가", imageName: "plus")
    
    let helpButton = LeftImageButton(title: "도움말", imageName: "questionmark.circle")
    
    init(homeState: HomeState) {
        self.homeState = homeState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.enterFlag.onNext(true)
                
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.enterFlag.onNext(false)
    }
    
    override func bind() {
        let input = WorkspaceListViewModel.Input(homeState: BehaviorSubject(value: homeState))
        
        let output = viewModel.transform(input: input)
        
        output.workspaceList
            .bind(to: tableView.rx.items(cellIdentifier: WorkspaceListCell.reuseIdentifier, cellType: WorkspaceListCell.self)) { (row, element, cell) in
                cell.workspaceImage.loadImage(from: element.thumbnail)
                cell.workspaceTitle.text = element.name
                cell.workspaceCreatedAt.text = element.createdAt
                
                if let savedID = KeychainManager.shared.read(account: .workspaceID) {
                    if "\(element.workspaceID)" == savedID {
                        cell.workspaceMenu.isHidden = false
                        cell.backgroundColor = Colors.BrandColor.gray
                    } else {
                        if row == 0 {
                            cell.workspaceMenu.isHidden = false
                            cell.backgroundColor = Colors.BrandColor.gray
                        }
                    }
                } else {
                    if row == 0 {
                        cell.workspaceMenu.isHidden = false
                        cell.backgroundColor = Colors.BrandColor.gray
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = Colors.BackgroundColor.secondary
        
        //뷰 우측 상단 및 하단 cornerRadius
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        
        addWorkspaceButton.addTarget(self, action: #selector(addWorkspaceButtonClicked), for: .touchUpInside)
        emptyListView.addWorkspaceButton.addTarget(self, action: #selector(addWorkspaceButtonClicked), for: .touchUpInside)
        
        [topView, titleLabel, addWorkspaceButton, helpButton].forEach {
            view.addSubview($0)
        }
        
        switch homeState {
        case .empty:
            [emptyListView].forEach {
                view.addSubview($0)
            }
            
        case .nonempty:
            print("otl")
            [tableView].forEach {
                view.addSubview($0)
            }
        }
        
    }
    
    override func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(topView.snp.bottom).offset(-17)
        }
        
        helpButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(41)
        }
        
        addWorkspaceButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(41)
            make.bottom.equalTo(helpButton.snp.top)
        }
        
        switch homeState {
        case .empty:
            emptyListView.snp.makeConstraints { make in
                make.top.equalTo(topView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(addWorkspaceButton.snp.top)
            }
        
        case .nonempty:
            print("otl")
            tableView.snp.makeConstraints { make in
                make.top.equalTo(topView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(addWorkspaceButton.snp.top)
            }
        }
    }
}

extension WorkspaceListViewController {
    
    @objc func addWorkspaceButtonClicked() {
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
