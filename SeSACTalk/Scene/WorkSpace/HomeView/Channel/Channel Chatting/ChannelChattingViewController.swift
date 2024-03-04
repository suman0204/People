//
//  ChannelChattingViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/22.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RealmSwift

class ChannelChattingViewController: BaseViewController {
    
    let repository = ChannelChatRepository()
    var tasks: Results<ChannelInfoTable>!
    var taskToken: NotificationToken?
    
    let viewModel = ChannelChattingViewModel()
    let disposeBag = DisposeBag()
    
//    let channelInfo =
    private var imageArray = [UIImage]()
    private var selections = [String : PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var itemProviders: [NSItemProvider] = []
    
    private lazy var chattingTableView = {
        let tableView = UITableView()
        tableView.register(ChattingCell.self, forCellReuseIdentifier: ChattingCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Colors.BrandColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private lazy var channelSettingButton = {
        let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(channelSettingButtonClicked))
        button.tintColor = Colors.BrandColor.black
        return button
    }()
    
    private let bottomView = {
        let view = UIView()
        view.backgroundColor = Colors.BackgroundColor.primary
        view.layer.cornerRadius = 8
        view.backgroundColor = Colors.BackgroundColor.primary
        return view
    }()
    
    private let plusButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = Colors.TextColor.secondary
        button.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var textView = {
        let textView = UITextView()
        textView.backgroundColor = Colors.BackgroundColor.primary
//        textView.backgroundColor = .yellow
        textView.text = textViewPlaceHolder
        textView.textColor = Colors.TextColor.secondary
        textView.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.delegate = self
        return textView
    }()
    
    private lazy var selectedImage = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(ChattingSelectedImageCell.self, forCellWithReuseIdentifier: ChattingSelectedImageCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = Colors.BackgroundColor.primary
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let sendButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SendInA"), for: .normal)
        button.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let textViewPlaceHolder: String = "메세지를 입력하세요"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ChannelChattingView DidLoad")
        self.navigationItem.title = "ARC가 뭐예요?"
        viewModel.enterFlag.onNext(true)
//        view.backgroundColor = Colors.BrandColor.green
        
        tasks = repository.fetchChannelTable(channelID: Int(KeychainManager.shared.read(account: .channelID) ?? "") ?? 0)
        taskToken = tasks.observe({ [weak self] changes in
            switch changes {
            case .initial:
                self?.chattingTableView.reloadData()
                self?.scrollToBottom()
            case .update(_, _, _, _):
                self?.chattingTableView.reloadData()
                self?.scrollToBottom()
            case .error(let error):
                print("tasktoken error", error)
            }
        })
        self.scrollToBottom()

//        SocketIOManager.shared.connectSocket(channelID: Int(KeychainManager.shared.read(account: .channelID) ?? "") ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        SocketIOManager.shared.connectSocket(channelID: Int(KeychainManager.shared.read(account: .channelID) ?? "") ?? 0)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        SocketIOManager.shared.disconnectSocket()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.enterFlag.onNext(false)
    }
    
    override func bind() {
        let input = ChannelChattingViewModel.Input(textInput: textView.rx.text.orEmpty, sendButtonClicekd: sendButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.sendButtonEnabled
            .asDriver()
            .drive(with: self) { owner, bool in
                owner.sendButton.isEnabled = bool
                owner.sendButton.setImage(UIImage(named: bool ? "SendA" : "SendInA"), for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BrandColor.white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = Colors.BrandColor.black
        
        self.navigationItem.rightBarButtonItem = channelSettingButton
        
        [textView, selectedImage].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [plusButton, stackView, sendButton].forEach {
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
            make.top.equalTo(textView.snp.top).offset(-8)
            make.top.equalTo(chattingTableView.snp.bottom).offset(16)
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-11)
            make.top.greaterThanOrEqualToSuperview().offset(11)
        }
  
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(plusButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.height.greaterThanOrEqualTo(18)
        }
        
        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        selectedImage.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview()
        }
        
//        selectedImage.isHidden = true
        
//        textView.snp.makeConstraints { make in
//            make.leading.equalTo(plusButton.snp.trailing).offset(8)
//            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
//            make.bottom.equalToSuperview().offset(-8)
//            make.top.equalToSuperview().offset(8)
//            make.height.greaterThanOrEqualTo(18)
//        }
        
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
    
    @objc
    func plusButtonClicked() {
        self.presentPicker()
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

//MARK: SelectedImageCollectionView
extension ChannelChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
//        let width = selectedImage.frame.width / 6
//        let height = width
//        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingSelectedImageCell.reuseIdentifier, for: indexPath) as? ChattingSelectedImageCell else { return UICollectionViewCell() }
        
        cell.imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 6
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
}

//MARK: PHPicker
extension ChannelChattingViewController: PHPickerViewControllerDelegate {
    
    //PHPicker 띄우기
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.any(of: [.images])
        config.selectionLimit = 5
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        
        var newSelections = [String : PHPickerResult]()
        
        for result in results {
            guard let identifier = result.assetIdentifier else { return }
            
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if itemProviders.isEmpty {
            imageArray.removeAll()
        } else {
            displayImage()
        }
    }
    
    private func displayImage() {
        let dispatchGroup = DispatchGroup()
        
        var imagesDict = [String : UIImage]()
        
        for (identifier, result) in selections {
            dispatchGroup.enter()
            
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            imagesDict[identifier] = image
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else { return }
                
                imageArray.removeAll()
                
                var imageDataArray: [Data] = []
                
                for identifier in self.selectedAssetIdentifiers {
                    guard let image = imagesDict[identifier] else { return }
                    imageArray.append(image)
                    imageDataArray.append(image.jpegData(compressionQuality: 0.3) ?? Data())
                }
                
                viewModel.imageData.onNext(imageDataArray)
                
                selectedImage.isHidden = false
                selectedImage.reloadData()
            }
        }
    }
}

extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.first?.chat.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChattingCell.reuseIdentifier, for: indexPath) as! ChattingCell
        
        guard let chatList = tasks.first?.chat else { return UITableViewCell() }
        let data = chatList[indexPath.row]
        
        cell.nameLabel.text = data.user?.nickname
        cell.chatTextLabel.text = data.content
        cell.profileImage.loadImage(from: data.user?.profileImage ?? "")
        cell.timeLabel.text = formatDate(dateString: data.createdAt)
        
        return cell
    }
    

}

extension ChannelChattingViewController {
    func formatDate(dateString: String) -> String {
//        let dateFormatter = ISO8601DateFormatter()
//        guard let date = dateFormatter.date(from: isoString) else {
//            return "Invalid Date"
//        }
//        
//        let calendar = Calendar.current
//        let now = Date()
//        
//        if calendar.isDateInToday(date) {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "hh:mm a"
//            let timeString = formatter.string(from: date)
//            return timeString
//        } else {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "M/d hh:mm a"
//            let dateString = formatter.string(from: date)
//            return dateString
//        }
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        
        if let date = isoDateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    @objc
    private func sendButtonClicked() {
        textView.text = ""
        imageArray.removeAll()
        selectedImage.reloadData()
        selectedImage.isHidden = true
        scrollToBottom()
    }
    
    func scrollToBottom(){
        print("Scroll To Bottom")
            DispatchQueue.main.async {
                let index = self.chattingTableView.numberOfRows(inSection: 0)
                if index > 0 {
                    let indexPath = IndexPath(row: index - 1, section: 0)
                    self.chattingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    
    func tableViewScrollToBottom(animated: Bool) {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
          let numberOfSections = self.chattingTableView.numberOfSections
//          let numberOfRows = self.chattingTableView.numberOfRows(inSection: numberOfSections - 1)
          let index = self.chattingTableView.numberOfRows(inSection: 0)
        if index > 0 {
          let indexPath = IndexPath(row: index-1, section: 0)
            self.chattingTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
        }
      }
    }
}
