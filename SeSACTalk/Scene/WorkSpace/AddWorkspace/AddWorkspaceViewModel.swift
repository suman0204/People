//
//  AddWorkspaceViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/19.
//

import Foundation
import RxSwift
import RxCocoa

class AddWorkspaceViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    let image: BehaviorSubject<Data> = BehaviorSubject(value: Data())
    let imageValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    struct Input {
//        let image: BehaviorSubject<Data>
        let name: ControlProperty<String>
        let description: ControlProperty<String>
        let addWorkspaceButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let nameValid: BehaviorSubject<Bool>
        let addWorkspaceButtonValid: BehaviorSubject<Bool>
        let validationArray: BehaviorSubject<Array<Bool>>
    }
    
    func transform(input: Input) -> Output {
        
        let nameValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        let addWorkspaceButtonValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        let validationArray: BehaviorSubject<Array<Bool>> = BehaviorSubject(value: [])
        
        input.name
            .map {
                $0.count > 0
            }
            .bind(to: addWorkspaceButtonValid)
            .disposed(by: disposeBag)
        
        input.name
            .map {
                $0.count > 1 && $0.count <= 30
            }
            .bind(to: nameValid)
            .disposed(by: disposeBag)
        

        //이미지, 워크스페이스 이름 유효성 묶음
        Observable.combineLatest(imageValid, nameValid)
            .map { imageValid, nameValid in
                return [imageValid, nameValid]
            }
            .bind(to: validationArray)
            .disposed(by: disposeBag)
        
        let inputData = Observable.combineLatest(input.name, input.description, image)

        //워크스페이스 생성 버튼 클릭 시 서버에 생성 요청
        input.addWorkspaceButtonClicked
            .withLatestFrom(validationArray)
            .filter {
                return $0.allSatisfy { $0 == true }
            }
            .withLatestFrom(inputData)
            .flatMapLatest { name, description, image in
                APIManager.shared.singleMultipartRequset(type: AddWorkspaceResponse.self, api: .addWorkspace(model: AddWorkspaceRequest(name: name, description: description, image: image)))
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print(result)
                    SwitchView.shared.switchView(viewController: TabBarController())
                    KeychainManager.shared.create(account: "workspaceID", value: "\(result.workspaceID)")
                case .failure(let error):
                    print("Add Workspace Error")
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(nameValid: nameValid, addWorkspaceButtonValid: addWorkspaceButtonValid, validationArray: validationArray)
    }
}
