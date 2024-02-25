//
//  ChannelChattingViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/22.
//

import UIKit
import RxSwift
import RxCocoa

class ChannelChattingViewController: BaseViewController {
    
//    let channelInfo =
    
    lazy var chattingTableView = {
        let tableView = UITableView()
        tableView.register(ChattingCell.self, forCellReuseIdentifier: ChattingCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Colors.BrandColor.white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var channelSettingButton = {
        let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(channelSettingButtonClicked))
        button.tintColor = Colors.BrandColor.black
        return button
    }()
    
    let bottomView = {
        let view = UIView()
        view.backgroundColor = Colors.BackgroundColor.primary
        view.layer.cornerRadius = 8
        view.backgroundColor = Colors.BackgroundColor.primary
        return view
    }()
    
    let plusButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = Colors.TextColor.secondary
        return button
    }()
    
    lazy var textView = {
        let textView = UITextView()
//        textView.backgroundColor = Colors.BackgroundColor.primary
        textView.backgroundColor = .yellow
        textView.text = textViewPlaceHolder
        textView.textColor = Colors.TextColor.secondary
        textView.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.delegate = self
        return textView
    }()
    
    let selectedImage = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        return collectionView
    }()
    
    let sendButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SendInA"), for: .normal)
        return button
    }()
    
    let textViewPlaceHolder: String = "메세지를 입력하세요"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ChannelChattingView DidLoad")
        self.navigationItem.title = "그냥 떠들고 싶을 때"

//        view.backgroundColor = Colors.BrandColor.green
    }
    
    override func bind() {
        
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BrandColor.white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = Colors.BrandColor.black
        
        self.navigationItem.rightBarButtonItem = channelSettingButton
        
        [plusButton, textView, selectedImage, sendButton].forEach {
            bottomView.addSubview($0)
        }
        
        [chattingTableView, bottomView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
            make.horizontalEdges.equalToSuperview().inset(16)
//            make.height.greaterThanOrEqualTo(38)
//            make.height.lessThanOrEqualTo(80)
            make.top.equalTo(textView.snp.top).offset(-10)
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-11)
            make.top.greaterThanOrEqualToSuperview().offset(11)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(plusButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.height.greaterThanOrEqualTo(18)
        }
        
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-9)
            make.top.greaterThanOrEqualToSuperview().offset(9)
        }
        
        chattingTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomView.snp.top).offset(-16)
        }
        
        
    }
    
}

extension ChannelChattingViewController {
    
    @objc
    func channelSettingButtonClicked() {
        
    }
}

//MARK: TextViewDelegate
extension ChannelChattingViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
  
        guard textView.contentSize.height < 39.0 else { textView.isScrollEnabled = true; return}
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { constraints in
            if constraints.firstAttribute == .height {
                constraints.constant = estimatedSize.height
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = Colors.TextColor.primary
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = Colors.TextColor.secondary
        }
    }
}


extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChattingCell.reuseIdentifier, for: indexPath) as! ChattingCell
        cell.nameLabel.text = "dhdsfddhdsfddhdsfd"
        cell.chatTextLabel.text = "adfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjadadfadfadfhakjdhfakjhfkjad"
        cell.profileImage.image = UIImage(systemName: "heart")
        cell.timeLabel.text = "1/1308:16 오전"
        
        return cell
    }
    

}
