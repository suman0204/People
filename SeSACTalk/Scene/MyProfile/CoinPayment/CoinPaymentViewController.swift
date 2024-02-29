//
//  CoinPaymentViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/29.
//

import UIKit
import RxSwift
import RxCocoa

final class CoinPaymentViewController: BaseViewController {
    
    let viewModel = CoinPaymentViewModel()
    
    lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = Colors.BackgroundColor.primary
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(CoinPaymentTableViewCell.self, forCellReuseIdentifier: CoinPaymentTableViewCell.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        title = "코인샵"
        view.backgroundColor = Colors.BackgroundColor.primary
        
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}


extension CoinPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinPaymentTableViewCell.reuseIdentifier, for: indexPath) as? CoinPaymentTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let data = viewModel.cointData.first[indexPath.row]
            cell.setData(data: data)
            return cell
        } else {
            let data = viewModel.cointData.second[indexPath.row]
            cell.setData(data: data)
            cell.payButton.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
            return cell
        }
        
    }

}

extension CoinPaymentViewController {
    
    @objc
    func payButtonClicked(_ sender: UIButton) {
        print("payButton")
    }
}
