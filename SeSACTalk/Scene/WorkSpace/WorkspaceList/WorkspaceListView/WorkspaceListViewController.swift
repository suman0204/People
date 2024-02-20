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

final class WorkspaceListViewController: BaseViewController {
    
    private let viewModel = WorkspaceListViewModel()
    private let disposeBag = DisposeBag()
    
    private let homeState: HomeState
    
    private var workspaceInfo: AddWorkspaceResponse?
    
    //NotificationCenter
    let notificationObservable = NotificationCenter.default.rx.notification(Notification.Name("EditComplete"))
    
    private let topView = {
        let view = UIView()
        view.backgroundColor = Colors.BackgroundColor.primary
        return view
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "워크스페이스"
        label.textColor = Colors.TextColor.primary
        label.font = .systemFont(ofSize: Typography.Title1.size, weight: Typography.Title1.weight)
        return label
    }()
    
    private let emptyListView = EmptyListView()
    
    private let tableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(WorkspaceListCell.self, forCellReuseIdentifier: WorkspaceListCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 72
        return tableView
    }()
    
    @objc let addWorkspaceButton = LeftImageButton(title: "워크스페이스 추가", imageName: "plus")
    
    private let helpButton = LeftImageButton(title: "도움말", imageName: "questionmark.circle")
    
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
        print("ListView WorkspaceID",KeychainManager.shared.read(account: .workspaceID))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ListView Did Appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.enterFlag.onNext(false)
        
        print("WorkspaceListView Disappear")
    }
    
    override func bind() {
        
        notificationObservable
            .subscribe(with: self) { owner, notification in
                owner.showToast(message: "워크스페이스가 편집외었습니다.")
            }
            .disposed(by: disposeBag)
        
        let input = WorkspaceListViewModel.Input(homeState: BehaviorSubject(value: homeState))
        
        let output = viewModel.transform(input: input)
        
        output.workspaceList
            .bind(to: tableView.rx.items(cellIdentifier: WorkspaceListCell.reuseIdentifier, cellType: WorkspaceListCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                cell.workspaceImage.loadImage(from: element.thumbnail)
                cell.workspaceTitle.text = element.name
                cell.workspaceCreatedAt.text = element.formattedCreatedAt
//                cell.backgroundColor = Colors.BackgroundColor.secondary
                
                let isAdmin = (KeychainManager.shared.read(account: .userID) == "\(element.ownerID)")
                
                if let savedID = KeychainManager.shared.read(account: .workspaceID) {
                    print("SavedID", savedID)
                    if "\(element.workspaceID)" == savedID {
                        print("SameSame", cell.workspaceCreatedAt)
                        cell.workspaceMenu.isHidden = false
                        cell.backgroundColor = Colors.BrandColor.gray
                        cell.workspaceMenu.rx.tap
                            .bind {
                                print("cell mene tapped")
                                self.showAlert(isAdmin: isAdmin)
                            }
                            .disposed(by: cell.disposeBag)
                        
                        self.workspaceInfo = element
                        
                    } else {
                            cell.backgroundColor = Colors.BackgroundColor.secondary
                            cell.workspaceMenu.isHidden = true
                    }
                } else {
                    if row == 0 {
                        cell.workspaceMenu.isHidden = false
                        cell.backgroundColor = Colors.BrandColor.gray
                        cell.workspaceMenu.rx.tap
                            .bind {
                                print("cell mene tapped")
                                self.showAlert(isAdmin: isAdmin)

                            }
                            .disposed(by: cell.disposeBag)
                        
                        self.workspaceInfo = element

                    } else {
                        cell.backgroundColor = Colors.BackgroundColor.secondary
                        cell.workspaceMenu.isHidden = true
                    }
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(AddWorkspaceResponse.self))
//            .map { "셀 선택 \($0) \($1)" }
            .subscribe(with: self, onNext: { owner, selection in
                print(selection.0.row)
                print(selection.1)
                let selectedIndex = selection.0
                
                owner.tableView.cellForRow(at: selectedIndex)?.backgroundColor = Colors.BrandColor.gray
                owner.tableView.visibleCells.forEach { cell in
                    if let cellIndexPath = owner.tableView.indexPath(for: cell), cellIndexPath != selectedIndex {
                        cell.backgroundColor = .clear
                    }
                }
                KeychainManager.shared.create(account: .workspaceID, value: "\(selection.1.workspaceID)")
                NotificationCenter.default.post(name: NSNotification.Name("ChangeWorkspace"), object: selection.1.workspaceID)
                owner.dismiss(animated: true)
            })
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
    
    @objc private func addWorkspaceButtonClicked() {
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
    
    private func showAlert(isAdmin: Bool) {
        let alert = UIAlertController()
        
        let workspaceEdit = UIAlertAction(title: "워크스페이스 편집", style: .default) { _ in
            self.editWorkspace()
        }
        let workspaceLeave = UIAlertAction(title: "워크스페이스 나가기", style: .default) { _ in
            self.adimLeaveButtonClicked(isAdmin: isAdmin)
        }
        let changeAdmin = UIAlertAction(title: "워크스페이스 관리자 변경", style: .default) { _ in
            self.changeAdmin()
        }
        let workspaceDelete = UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { _ in
            self.deletButtonClicked()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)

        if isAdmin {
            [workspaceEdit, workspaceLeave, changeAdmin, workspaceDelete, cancel].forEach {
                alert.addAction($0)
            }
        } else {
            [workspaceLeave, cancel].forEach {
                alert.addAction($0)
            }
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func editWorkspace() {
        print("EditWorkspace")
        
        guard let workspaceInfo = workspaceInfo else {
            return
        }
        
        let vc = WorkspaceEditViewController(workspaceInfo: workspaceInfo)
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [
                .large()
            ]
            
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
        
    }
    
    private func changeAdmin() {
        print("ChangeAdmin")
        
        let vc = ChangeAdminViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [
                .large()
            ]
            
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
        
    }
    
    private func adimLeaveButtonClicked(isAdmin: Bool) {
        print("Leave")
        let popUpViewController: PopUpView
        if isAdmin {
            popUpViewController = PopUpView(titleText: "워크스페이스 나가기", bodyText: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리 자를 다른 멤버로 변경한 후 나갈 수 있습니다.", buttonTitle: "확인", buttonType: .single, buttonAction: .workspaceExit, workspaceID: workspaceInfo?.workspaceID)
        } else {
            popUpViewController = PopUpView(titleText: "워크스페이스 나가기", bodyText: "정말 이 워크스페이스를 떠나시겠습니까?", buttonTitle: "확인", buttonType: .double, buttonAction: .workspaceExit, workspaceID: workspaceInfo?.workspaceID)
        }
        popUpViewController.modalPresentationStyle = .overFullScreen
        
        present(popUpViewController, animated: true)
    }
    
    private func deletButtonClicked() {
        print("Delete")
        let popUpViewController = PopUpView(titleText: "워크스페이스 삭제", bodyText: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다..", buttonTitle: "삭제", buttonType: .double, buttonAction: .workspaceDelete, workspaceID: workspaceInfo?.workspaceID)
        popUpViewController.modalPresentationStyle = .overFullScreen
        
        present(popUpViewController, animated: true)
    }
}
