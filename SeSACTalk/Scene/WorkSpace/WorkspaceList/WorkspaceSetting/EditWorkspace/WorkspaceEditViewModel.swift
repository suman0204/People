//
//  WorkspaceEditViewModel.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/08.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkspaceEditViewModel: ViewModelType {
    
//    let workspaceName: String = ""
    
    let disposeBag = DisposeBag()
    
    let image: BehaviorSubject<Data> = BehaviorSubject(value: Data())
    let imageValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    struct Input {
        let workspace: AddWorkspaceResponse
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
        
        print("ViewModel Data", try! image.value())
        
        let nameValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        let addWorkspaceButtonValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        let validationArray: BehaviorSubject<Array<Bool>> = BehaviorSubject(value: [])

//        input.name
////            .distinctUntilChanged()
//            .map {
//                $0.count > 0
//            }
//            .bind(to: addWorkspaceButtonValid)
//            .disposed(by: disposeBag)

        let nameValidG = input.name
            .map {
                print($0)
                return $0 != input.workspace.name
            }

        
        Observable.combineLatest(nameValidG, imageValid)
            .map { nameValidG, imageValid in
                print(nameValidG, imageValid)

                return nameValidG || imageValid
            }
//            .subscribe(with: self, onNext: { owner, bool in
//                print("Combine Bool", bool)
//            })
            .debug()
            .bind(to: addWorkspaceButtonValid)
            .disposed(by: disposeBag)
        
        
        input.name
//            .distinctUntilChanged()
            .map {
                $0.count > 1 && $0.count <= 30 && $0 != $0
            }
            .distinctUntilChanged()
            .bind(to: nameValid)
            .disposed(by: disposeBag)
        

        //이미지, 워크스페이스 이름 유효성 묶음
        Observable.combineLatest(imageValid, nameValid)
            .map { imageValid, nameValid in
                print("Edit Valid", imageValid, nameValid)
                return [imageValid, nameValid]
            }
            .bind(to: validationArray)
            .disposed(by: disposeBag)
        
        let inputData = Observable.combineLatest(input.name, input.description, image)

        //워크스페이스 생성 버튼 클릭 시 서버에 생성 요청
        input.addWorkspaceButtonClicked
//            .withLatestFrom(validationArray)
//            .filter {
//                return $0.allSatisfy { $0 == true }
//            }
            .withLatestFrom(inputData)
            .flatMapLatest { name, description, image in
                print("network Data", image)
                return APIManager.shared.singleMultipartRequset(type: AddWorkspaceResponse.self, api: .editWorspace(id: input.workspace.workspaceID, model: AddWorkspaceRequest(name: name, description: description, image: image)))
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print("Edit Workspace Success", result)
//                    SwitchView.shared.switchView(viewController: TabBarController())
//                    KeychainManager.shared.create(account: .workspaceID, value: "\(result.workspaceID)")
                case .failure(let error):
                    print("Edit Workspace Error")
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(nameValid: nameValid, addWorkspaceButtonValid: addWorkspaceButtonValid, validationArray: validationArray)
    }
}
