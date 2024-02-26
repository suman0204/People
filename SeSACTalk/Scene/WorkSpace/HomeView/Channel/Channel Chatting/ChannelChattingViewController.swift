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

class ChannelChattingViewController: BaseViewController {
    
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
        return button
    }()
    
    private let textViewPlaceHolder: String = "메세지를 입력하세요"
    
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
                
                selectedImage.isHidden = false
                selectedImage.reloadData()
            }
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
        cell.chatTextLabel.text = "ad\nf"
        cell.profileImage.image = UIImage(systemName: "heart")
        cell.timeLabel.text = "1/13\n08:16 오전"
        
        return cell
    }
    

}
