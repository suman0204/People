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
        
        //ChannelTableView
//        output.channels
//            .bind(to: tableView.rx.items(cellIdentifier: ChannelTableViewCell.reuseIdentifier, cellType: ChannelTableViewCell.self)) { row, element, cell in
//                
//                if self.isOpen {
//                    cell.titleLabel.text = element.name
//                } else {
//                    cell.isHidden = true
//                }
//            }
//            .disposed(by: disposeBag)
        
//        output.channels
//            .bind(to: tableView2.rx.items(cellIdentifier: ChannelTableViewCell.reuseIdentifier, cellType: ChannelTableViewCell.self)) { row, element, cell in
//            
//                cell.titleLabel.text = element.name
//            }
//            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected
//            .subscribe(with: self) { owner, indexPath in
//                if owner.isOpen == false {
//                    owner.tableView.deleteRows(at: [indexPath], with: .fade)
//                } else {
//                    owner.tableView.insertRows(at: [indexPath], with: .fade)
//                }
//            }
//            .disposed(by: disposeBag)
        
//        output.workspaceList
//            .bind(to: tableView.rx.items(cellIdentifier: WorkspaceListCell.reuseIdentifier, cellType: WorkspaceListCell.self)) { (row, element, cell) in
//                cell.workspaceImage.kf.setImage(with: URL(string: element.thumbnail))
//                cell.workspaceTitle.text = element.name
//                cell.workspaceCreatedAt.text = element.createdAt
//            }
//            .disposed(by: disposeBag)
        
//        var outputChannels: [Channel] = []
//        output.channels.subscribe(with: self) { owner, channels in
//            outputChannels = channels
//            print("Channels Channels", channels)
//        }
//        .disposed(by: disposeBag)
//        
//        print("outputChannels.map { SectionItem.channelItem($0)}",outputChannels.map { SectionItem.channelItem($0)})
        
//        // MARK: TableView DataSource
        let dataSource = HomeViewController.dataSource()

        output.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
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
                    let cell: ChannelTableViewCell = table.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifier, for: indexPath) as! ChannelTableViewCell
                    cell.titleLabel.text = channel.name
                    return cell
                case let .dmItem(dm):
                    let cell = table.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifier, for: indexPath)
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isOpen ? 41 : 0
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifier, for: indexPath)
//        return cell
//    }
    
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

