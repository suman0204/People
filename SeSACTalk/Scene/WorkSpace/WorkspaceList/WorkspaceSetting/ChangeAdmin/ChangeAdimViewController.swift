//
//  ChangeAdimViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/14.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangeAdminViewController: BaseViewController {
    
    private lazy var workspaceMemebers: WorkspaceMembers = []
    
    private lazy var membersTable = {
       let tableView = UITableView()
        tableView.register(ChangeAdminTableCell.self, forCellReuseIdentifier: ChangeAdminTableCell.reuseIdentifier)
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //dismiss Button
    private lazy var dismissButton = {
        let button = UIBarButtonItem(image: UIImage(named: "Xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        button.tintColor = Colors.BrandColor.black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let workspaceID = KeychainManager.shared.read(account: .workspaceID),  let intID = Int(workspaceID) else { return }
        
        APIManager.shared.request(type: WorkspaceMembers.self, api: .getWorkspaceMember(id: intID)) { result in
            switch result {
            case .success(let response):
                print("Get Workspace Member Success")
                print(response)
                self.workspaceMemebers = response
                self.membersTable.reloadData()
            case .failure(let error):
                print("Get Workspace Member failure")
                print(error)
            }
        }
    }
    
    override func bind() {
        
        
        
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BackgroundColor.primary
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundColor.secondary
        
        self.navigationItem.leftBarButtonItem = dismissButton
    
        self.title = "워크스페이스 관리자 변경"
        
        [membersTable].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        membersTable.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ChangeAdminViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Workspace Count",workspaceMemebers.count)
        return workspaceMemebers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChangeAdminTableCell.reuseIdentifier, for: indexPath) as! ChangeAdminTableCell
        
        if workspaceMemebers.count == 1 {
            print("Impossible Change")
            let popUpViewController = PopUpView(titleText: "워크스페이스 관리자 변경 불가", bodyText: "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 워크스페이스에 초대해보세요.", buttonTitle: "확인", buttonType: .single, buttonAction: nil, workspaceID: nil)
            popUpViewController.modalPresentationStyle = .overFullScreen
            
            present(popUpViewController, animated: true)
            
            return cell
        } else {
            
            let data = workspaceMemebers[indexPath.row]
            
            cell.setData(image: data.profileImage ?? "", name: data.nickname, email: data.email)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = workspaceMemebers[indexPath.row].nickname
        
        let popUpViewController = PopUpView(titleText: "\(name) 님을 관리자로 지정하시겠습니까?", bodyText: "워크스페이스 관리자는 다음과 같은 권한이 있습니다. \n\n워크스페이스 이름 또는 설명 변경 \n워크스페이스 삭제 \n워크스페이스 멤버 초대", buttonTitle: "확인", buttonType: .double, buttonAction: .workspaceChangeAdmin, workspaceID: nil)
        popUpViewController.modalPresentationStyle = .overFullScreen
        
        present(popUpViewController, animated: true)
        
    }
    
}

extension ChangeAdminViewController {
    
    @objc
    func dismissButtonClicked() {
        self.dismiss(animated: true)
    }
}
