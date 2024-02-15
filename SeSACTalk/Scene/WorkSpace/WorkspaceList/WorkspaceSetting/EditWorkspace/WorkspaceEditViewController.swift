//
//  WorkspaceEditViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/08.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkspaceEditViewController: BaseViewController {
    
    private let viewModel = WorkspaceEditViewModel()
    
    private let disposeBag = DisposeBag()
    
    let workspaceInfo: AddWorkspaceResponse
    
    private let imageSelectView = {
        let view = UIView()
        return view
    }()
    
    private lazy var workspaceImageView = {
        let imageView = UIImageView(frame: .zero)
//        imageView.image = UIImage(named: "workspace")
        imageView.loadImage(from: workspaceInfo.thumbnail)
//        viewModel.image = imageView.image?.jpegData(compressionQuality: 0.5)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        print("Lazy", imageView.image)
        return imageView
    }()
    
    private let cameraImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "Camera")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var workspaceNameTextField = {
        let view = CustomTextFieldView(type: .normal)
        view.labelText = "워크스페이스 이름"
        view.placeholder = "워크스페이스 이름을 입력하세요 (필수)"
        view.inputTextField.text = workspaceInfo.name
        return view
    }()

    private lazy var workspaceDescriptionTextField = {
        let view = CustomTextFieldView(type: .normal)
        view.labelText = "워크스페이스 설명"
        view.placeholder = "워크스페이스를 설명하세요 (옵션)"
        view.inputTextField.text = workspaceInfo.description
        return view
    }()
    
    private let editWorkspaceButton = CustomButton(title: "저장", setbackgroundColor: Colors.BrandColor.inactive)
    
    //dismiss Button
    private lazy var dismissButton = {
        let button = UIBarButtonItem(image: UIImage(named: "Xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        button.tintColor = Colors.BrandColor.black
        return button
    }()
    
    //이미지 picker
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    init(workspaceInfo: AddWorkspaceResponse) {
        self.workspaceInfo = workspaceInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Bind", workspaceImageView.image)
        guard let data = workspaceImageView.image?.jpegData(compressionQuality: 0.5) else {
            print("nil image")
            return }
        print("VC Data", data)
        self.viewModel.image
            .onNext(data)

    }
    
    override func bind() {
//        print("Bind", workspaceImageView.image)
//        guard let data = workspaceImageView.image?.jpegData(compressionQuality: 0.5) else {
//            print("nil image")
//            return }
//        print("VC Data", data)
//        self.viewModel.image
//            .onNext(data)
        viewModel.editSuccess = { [weak self] in
            self?.dismissButtonClicked()
        }
        
        let input = WorkspaceEditViewModel.Input(workspace: workspaceInfo, name: workspaceNameTextField.inputTextField.rx.text.orEmpty, description: workspaceDescriptionTextField.inputTextField.rx.text.orEmpty, editWorkspaceButtonClicked: editWorkspaceButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.editWorkspaceButtonValid
            .subscribe(with: self) { owner, bool in
                print("workspaceButton Valid", bool)
                let color: UIColor = bool ? Colors.BrandColor.green : Colors.BrandColor.inactive
                owner.editWorkspaceButton.backgroundColor = color
                owner.editWorkspaceButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        editWorkspaceButton.rx.tap
            .subscribe(with: self) { owner, _ in
                guard let invalidIndex = try? output.validationArray.value().firstIndex(of: false) else { return }
                
                if invalidIndex == 0 {
                    owner.showToast(message: AddWorkspaceState(rawValue: 0)?.description ?? "")
                } else if invalidIndex == 1 {
                    owner.showToast(message: AddWorkspaceState(rawValue: 1)?.description ?? "")
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configureView() {
        view.backgroundColor = Colors.BackgroundColor.primary
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundColor.secondary
        
        self.navigationItem.leftBarButtonItem = dismissButton
        
        let imageSelectViewTap = UITapGestureRecognizer(target: self, action: #selector(selectImageButtonClicked))
        imageSelectView.addGestureRecognizer(imageSelectViewTap)
        imageSelectView.isUserInteractionEnabled = true
    
        self.title = "워크스페이스 편집"
        
        [workspaceImageView, cameraImageView].forEach {
            imageSelectView.addSubview($0)
        }
        
        [/*selectImageButton*/imageSelectView, workspaceNameTextField, workspaceDescriptionTextField, editWorkspaceButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
//        selectImageButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
//            make.centerX.equalToSuperview()
//            make.size.equalTo(70)
//        }
        imageSelectView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        workspaceImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.centerX.equalTo(workspaceImageView.snp.trailing).offset(-7)
            make.centerY.equalTo(workspaceImageView.snp.bottom).offset(-5)
            make.size.equalTo(24)
        }
        
        workspaceNameTextField.snp.makeConstraints { make in
            make.top.equalTo(imageSelectView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
        }
        
        workspaceDescriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(workspaceNameTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
        }
        
        editWorkspaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
            make.top.lessThanOrEqualTo(workspaceDescriptionTextField.snp.bottom).offset(447)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
}


extension WorkspaceEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //sheet dismiss
    @objc
    private func dismissButtonClicked() {
        self.dismiss(animated: true)
    }
    
    //imagePicker
    @objc
    private func selectImageButtonClicked() {
        let alert =  UIAlertController(title: "워크스페이스 이미지", message: "워크스페이스 프로필 이미지를 선택하세요", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "앨범에서 가져오기", style: .default) { (action) in self.openLibrary() }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    //앨범 열기
    private func openLibrary(){
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: false, completion: nil)
    }
    
    //카메라 열기
    private func openCamera(){
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: false, completion: nil)
    }
    
    //delegate
    //이미지 선택 완료 시
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage? = nil
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { // 수정된 이미지가 있을 경우
            selectedImage = editedImage
            guard let data = editedImage.jpegData(compressionQuality: 0.5) else { return }
            
            self.viewModel.image
                .onNext(data)
            
            self.viewModel.imageValid.onNext(true)
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { // 원본 이미지가 있을 경우
            selectedImage = originalImage
            guard let data = originalImage.jpegData(compressionQuality: 0.5) else { return }
            
            self.viewModel.image
                .onNext(data)
            
            self.viewModel.imageValid.onNext(true)

        }
        
        // 버튼에 이미지 보여주기
//        selectImageButton.setImage(selectedImage, for: .normal)
        workspaceImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
}
