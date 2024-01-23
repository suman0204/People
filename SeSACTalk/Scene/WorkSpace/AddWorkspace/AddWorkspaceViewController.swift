//
//  AddWorkspaceViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/18.
//

import UIKit
import RxSwift
import RxCocoa

final class AddWorkspaceViewController: BaseViewController {
    
    let viewModel = AddWorkspaceViewModel()
    
    let disposeBag = DisposeBag()
    
    let selectImageButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "addworkspaceimage"), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectImageButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let workspaceNameTextField = {
        let view = CustomTextFieldView(type: .normal)
        view.labelText = "워크스페이스 이름"
        view.placeholder = "워크스페이스 이름을 입력하세요 (필수)"
        return view
    }()

    let workspaceDescriptionTextField = {
        let view = CustomTextFieldView(type: .normal)
        view.labelText = "워크스페이스 설명"
        view.placeholder = "워크스페이스를 설명하세요 (옵션)"
        return view
    }()
    
    let addWorkspaceButton = CustomButton(title: "완료", setbackgroundColor: Colors.BrandColor.inactive)
    
    //dismiss Button
    lazy var dismissButton = {
        let button = UIBarButtonItem(image: UIImage(named: "Xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        button.tintColor = Colors.BrandColor.black
        return button
    }()
    
    //이미지 picker
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {

        let input = AddWorkspaceViewModel.Input(name: workspaceNameTextField.inputTextField.rx.text.orEmpty, description: workspaceDescriptionTextField.inputTextField.rx.text.orEmpty, addWorkspaceButtonClicked: addWorkspaceButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.addWorkspaceButtonValid
            .subscribe(with: self) { owner, bool in
                let color: UIColor = bool ? Colors.BrandColor.green : Colors.BrandColor.inactive
                owner.addWorkspaceButton.backgroundColor = color
                owner.addWorkspaceButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        addWorkspaceButton.rx.tap
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
    
        self.title = "워크스페이스 생성"
        
        [selectImageButton, workspaceNameTextField, workspaceDescriptionTextField, addWorkspaceButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        selectImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        workspaceNameTextField.snp.makeConstraints { make in
            make.top.equalTo(selectImageButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
        }
        
        workspaceDescriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(workspaceNameTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
        }
        
        addWorkspaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
            make.top.lessThanOrEqualTo(workspaceDescriptionTextField.snp.bottom).offset(447)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
}


extension AddWorkspaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //sheet dismiss
    @objc
    func dismissButtonClicked() {
        self.dismiss(animated: true)
    }
    
    //imagePicker
    @objc
    func selectImageButtonClicked() {
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
    func openLibrary(){
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: false, completion: nil)
    }
    
    //카메라 열기
    func openCamera(){
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
        selectImageButton.setImage(selectedImage, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
