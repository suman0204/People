//
//  HomeInitialViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/25.
//

import UIKit

class HomeInitialViewController: BaseViewController {
    
    lazy var tableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.reuseIdentifier)
        tableView.register(ChannelHeaderView.self, forHeaderFooterViewReuseIdentifier: ChannelHeaderView.reuseIdentifier)
        tableView.register(ChannelFooterView.self, forHeaderFooterViewReuseIdentifier: ChannelFooterView.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HomeInitialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelHeaderView.reuseIdentifier)
            return header
        } else {
            return UITableViewHeaderFooterView()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelFooterView.reuseIdentifier)
        return footer
    }
    
}
