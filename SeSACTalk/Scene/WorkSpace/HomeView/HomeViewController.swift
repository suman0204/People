//
//  HomeViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

enum HomeState {
    case empty
    case nonempty
}

final class HomeViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = HomeViewModel()
    
    var homeState: HomeState
    
    let headerView = HomeHeaderView()
    
    let emptySpaceView = EmptyView()
    
    private var isOpen: Bool = true
    
    lazy var tableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.reuseIdentifier)
        tableView.register(ChannelHeaderView.self, forHeaderFooterViewReuseIdentifier: ChannelHeaderView.reuseIdentifier)
        tableView.register(ChannelFooterView.self, forHeaderFooterViewReuseIdentifier: ChannelFooterView.reuseIdentifier)
        tableView.register(DmTableViewCell.self, forCellReuseIdentifier: DmTableViewCell.reuseIdentifier)
        tableView.register(DMHeaderView.self, forHeaderFooterViewReuseIdentifier: DMHeaderView.reuseIdentifier)
        tableView.register(DMFooterView.self, forHeaderFooterViewReuseIdentifier: DMFooterView.reuseIdentifier)
        tableView.register(AddMemberHeaderView.self, forHeaderFooterViewReuseIdentifier: AddMemberHeaderView.reuseIdentifier)

        tableView.delegate = self
//        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(homeState: HomeState) {
        self.homeState = homeState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        viewModel.enterFlag.onNext(true)
        
        print("HomeView Didload", KeychainManager.shared.read(account: .workspaceID))
//        APIManager.shared.singleRequest(type: <#T##Decodable.Protocol#>, api: <#T##Router#>)
        
        print(homeState)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("HomeVC WillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.layer.addBorder([.bottom], color: Colors.BrandColor.gray, width: 1)

        print("HomeViewController DidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("HomeViewController DidDisappear")
        viewModel.enterFlag.onNext(false)
    }
    
    override func bind() {
        let input = HomeViewModel.Input(homeState: BehaviorSubject(value: homeState))
        
        let output = viewModel.transform(input: input)
        
        output.workspaceList
            .subscribe(with: self) { owner, workspaceList in
                print("HomeView WorkspaceList",workspaceList)
            }
            .disposed(by: disposeBag)
        
        output.workspace
            .subscribe(with: self) { owner, workspace in
                owner.headerView.workspaceName.text = workspace.name
                print("Workspace Name", workspace.name)
                owner.headerView.workspaceImage.loadImage(from: workspace.thumbnail)
//                owner.headerView.profileImage.loadImage(from: workspace.)
            }
            .disposed(by: disposeBag)
        
//        // MARK: TableView DataSource
        let dataSource = HomeViewController.dataSource()

        output.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(SectionItem.self))
            .subscribe(with: self) { owner, selected in
                print(selected)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SectionItem.self)
            .subscribe(with: self) { owner, item in
                switch item {
                case let .channelItem(channel):
                    // 채널 셀이 선택된 경우에 대한 처리
                    print("Selected Channel:", channel.name)
                    let vc = ChannelChattingViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                    
                    KeychainManager.shared.create(account: .channelName, value: channel.name)
                    KeychainManager.shared.create(account: .channelID, value: String(channel.channelID))

                case let .dmItem(dm):
                    // DM 셀이 선택된 경우에 대한 처리
                    print("Selected DM:", dm.user)
                case .addMemberItem:
                    // 추가 멤버 셀이 선택된 경우에 대한 처리
                    print("Selected Add Member Cell")
                }
            }
            .disposed(by: disposeBag)
    }
    

    
    override func configureView() {
        view.backgroundColor = .white
                
        //헤더뷰의 title에 제스쳐 추가
        let headerViewTap = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
        headerView.workspaceName.addGestureRecognizer(headerViewTap)
        headerView.workspaceName.isUserInteractionEnabled = true

        switch homeState {
        case .empty:
            [headerView, emptySpaceView].forEach {
                view.addSubview($0)
            }
            
            emptySpaceView.addWorkspaceButton.addTarget(self, action: #selector(addWorspaceButtonClicked), for: .touchUpInside)
            
        case .nonempty:
            [headerView, tableView].forEach {
                view.addSubview($0)
            }
        }
    }
    
    override func setConstraints() {
        
        switch homeState {
        case .empty:
            headerView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(44)
            }
            
            emptySpaceView.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            
        case .nonempty:
            headerView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(44)
            }
            
            tableView.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }

        }
    }
    
}

extension HomeViewController {
    
    @objc func headerViewTapped() {
        print("headerview tap")
        let workspaceList = WorkspaceListViewController(homeState: homeState)
        let menu = SideMenuNavigation(rootViewController: workspaceList)
        
        present(menu, animated: true)
    }
    
    @objc func addWorspaceButtonClicked() {
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
    
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel> {
        return RxTableViewSectionedReloadDataSource<SectionModel>(
            configureCell: { dataSource, table, indexPath, item in
                switch dataSource[indexPath] {
                case let .channelItem(channel):
                    print("DataSource Channel", channel)
                    let cell: ChannelTableViewCell = table.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifier, for: indexPath) as! ChannelTableViewCell
                    cell.titleLabel.text = channel.name
                    return cell
                case let .dmItem(dm):
                    let cell = table.dequeueReusableCell(withIdentifier: DmTableViewCell.reuseIdentifier, for: indexPath) as! DmTableViewCell
                    print("DataSource DM", dm)
                    cell.setData(dm: dm)
                    return cell
                case let .addMemberItem:
                    let cell = table.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifier, for: indexPath)
                    return cell
                }
            }
        )
    }
    
}

extension HomeViewController: UITableViewDelegate/*, UITableViewDataSource*/ {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isOpen ? 41 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelHeaderView.reuseIdentifier)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableHeaderViewTapped(_:)))
            header?.addGestureRecognizer(tapGesture)
            return header
        } else if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DMHeaderView.reuseIdentifier)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableHeaderViewTapped(_:)))
            header?.addGestureRecognizer(tapGesture)
            return header
        } else if section == 2 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddMemberHeaderView.reuseIdentifier)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableHeaderViewTapped(_:)))
            header?.addGestureRecognizer(tapGesture)
            return header
        } else {
            return UITableViewHeaderFooterView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0{
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelFooterView.reuseIdentifier)
            return footer
        } else if section == 1 {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DMFooterView.reuseIdentifier)
            return footer
        } else {
            return UITableViewHeaderFooterView()
        }
        
    }
    
    @objc func tableHeaderViewTapped(_ sender: UITapGestureRecognizer) {
        isOpen.toggle()
        tableView.footerView(forSection: 0)?.isHidden = isOpen ? false : true
        tableView.reloadData()
        print("toggle")
    }
}

