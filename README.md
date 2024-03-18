<p align="left">
  <img width="100" alt="image" src="https://github.com/suman0204/People/assets/18048754/f7b94215-c9b8-4478-8c47-1a70c27991c2">
</p>

# People


**관심있는 분야에 대해 소통하는 그룹 메신저 앱**

<p align="center">
<img src="https://github.com/suman0204/People/assets/18048754/4925ad01-3030-4ffd-8625-51f685d249ed" width="19%" height="20%">
<img src="https://github.com/suman0204/People/assets/18048754/fb1056e3-08f2-4fd3-9c14-714a2aeb155b" width="19%" height="20%">
<img src="https://github.com/suman0204/People/assets/18048754/f27f2b9e-91ed-4efe-a015-53af4e7be839" width="19%" height="20%">
<img src="https://github.com/suman0204/People/assets/18048754/0a0ddcc8-a8b3-4ba2-9e4f-6562c1ec2aa2" width="19%" height="20%">
<img src="https://github.com/suman0204/People/assets/18048754/fa8b68f4-a26c-410e-89d7-830ef7491c1b" width="19%" height="20%">
</p>

## 프로젝트 소개


> 앱 소개
> 
- 소셜 로그인(애플, 카카오), 이메일 로그인 기능
- 워크스페이스 편집, 삭제 등 관리 기능
- 채널 실시간 채팅 기능
- 채팅 Remote Notification 실시간 수신
- 앱 내 결제 기능

---

> 주요 기능
> 
- **RxSwift** 기반 **MVVM** **Input/Output** 패턴 적용을 통한 비즈니스 로직 분리 및 가독성 개선
- **final**, **private** 사용을 통한 컴파일 **최적화** 및 **은닉화**
- **KakaoSDK**, **AuthenticationServices**를 활용한 **소셜 로그인**
- **Alamofire**의 **URLRequestConvertible**을 통한 **Router 패턴** 구성 및 네트워크 요청 **추상화**와 **모듈화**
- **Toast Message**, **First Responder** 활용한 **RxSwift** 기반 **반응형 UI** 구현
- **SocketIO** 활용한 양방향 실시간 채팅 구현
- **Realm DB**에 과거 채팅 내역 저장을 통한 채팅 **네트워크 요청 최소화**
- **RxDataSource**를 활용한 **다중 섹션** 테이블뷰 구성
- **Firebase Cloud Messaging**을 통한 **Remote Push Notification** 수신
- **PG(Payment Gateway)**를 활용한 **WebView** 기반 결제 시스템 구현 및 **결제 영수증 검증**을 통한 **유효성 확인**

---

> 개발 환경
> 
- 최소 버전 : iOS 16.0
- 개발 인원: 1인
- 개발 기간: 2023.01.02 ~ 2023.02.28

---

> 기술 스택
> 
- UIKit, WebKit, PhotosUI
- SnapKit, Alamofire, Kingfisher, RxSwift,  RxDataSource, IQKeyboardManagerSwift, KakaoOpenSDK, SideMenu, Realm, SocketIO, Firebase(FCM), iamport-ios,
- MVVM, Input/Output, Singleton, Repository, DTO

---

<br/>

## 트러블 슈팅


### 1. CustomView 생성시 init 시점에 따른 뷰 변경점

**문제점**

텍스트필드와 버튼을 가진 커스텀뷰 구성 후 **enum을 활용**하여 케이스에 따라서 **다른 UI**를 보여주도록 구성
→ **ViewController**에서 인스턴스 생성 시 **뷰의 타입을 할당**하였으나 타입이 적용되지 않는 문제

```swift
enum textFieldViewType {
    case normal
    case withButton
}

class CustomTextFieldView: UIView {

		...
    
    var type: textFieldViewType?
    
		...
		    
    func configureView() {
        guard let type = type else { return }
        print(type)
        switch type {
        case .normal:
            [titleLabel, inputTextField].forEach {
                addSubview($0)
            }

        case .withButton:
            [titleLabel, inputTextField, validButton].forEach {
                addSubview($0)
            }
        }
    }
    
    func setConstraints() {
        guard let type = type else { return }

        switch type {
        case .normal:
						...
            
        case .withButton:
						...
        }
    }
}
```

```swift
final class SignUpViewController: BaseViewController {

		...
    
    lazy var emailTextFieldView = {
        **let view = CustomTextFieldView()**
        **view.type = .withButton**
				...
        return view
    }()
```

**해결법**

커스텀뷰의 **인스턴스 생성시** **초기화**를 통해 버튼의 타입을 지정해주어서 원하는 타입의 뷰가 화면에 보여질 수 있게 만듦

```swift

class CustomTextFieldView: UIView {
    
    **init(type: textFieldViewType)** {
        super.init(frame: .zero)
        **self.type = type**
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
```

```swift
final class SignUpViewController: BaseViewController {

    lazy var emailTextFieldView = {
        **let view = CustomTextFieldView(type: .withButton)**
				...

        return view
    }()
```

<br/>

---

### 2. **Generic**을 활용한 네트워크 호출 코드 추상화 및 재사용성 증진

**문제점**

서버에 요청해야하는 API 종류가 많음에 따라 각기 다른 요청을 위한 메서드를 만들면 너무 많은 메서드가 필요

**해결법**

**Generic**을 활용하여 일반적인 네트워크 요청, Single Trait을 활용한 요청, Multipart/form-data 요청 위한 메서드 등 상황에 맞게 **추상화**하여 **재사용**

```swift
func request<T: Decodable>(type: T.Type, api: Router, completion: @escaping (Result<T, CommonError>) -> Void) {
    
    AF.request(api, interceptor: Interceptor.shared).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
        switch response.result {
        case .success(let data):
						...
						
        case .failure(let error):	          
	          ...
            
        }
    }
}

func singleRequest<T: Decodable>(type: T.Type, api: Router) -> Single<Result<T, CommonError>> {
    return Single.create { [weak self] single in
        self?.request(type: T.self, api: api) { response in
            switch response {
            case .success(let success):         
                ...
                
            case .failure(let failure):
                ...
                
            }
        }
        return Disposables.create()
    }
}

func singleMultipartRequset<T: Decodable>(type: T.Type, api: Router) -> Single<Result<T, CommonError>> {
    return Single.create { single in
        AF.upload(multipartFormData: api.multipart, with: api, interceptor: Interceptor.shared).responseDecodable(of: T.self) { response in
            switch response.result {
            case.success(let result):  
                ...
                
            case .failure(let error):    
								...
								
        }
        return Disposables.create()
    }
}
```

<br/>

---

### 3. socket.io의 버전 오류

**문제**

소켓 연결을 코드를 구성하였지만 연결이 계속 실패하는 이슈

<p align="center">
<img src="https://github.com/suman0204/People/assets/18048754/1681734b-e913-4b1c-977c-4576ab3425a6" width="60%" height="60%">
</p>

**해결법**

공식 깃허브의 다운 절차를 따라하였으나, 최신 버전이 아닌 이전 버전이 예시로 나와 있음을 인지하지 못하고 그대로 다운함이 원인

<p align="center">
<img src="https://github.com/suman0204/People/assets/18048754/45d7aa11-52c0-4461-821b-c64c4aaacebf" width="40%" height="40%">
&nbsp&nbsp&nbsp 
<img src="https://github.com/suman0204/People/assets/18048754/517f1525-b97b-41b0-b5ea-15ffea2af9b1" width="40%" height="40%">
</p>

최신 버전으로 다시 설치한 후 정상적으로 동작

<p align="center">
<img src="https://github.com/suman0204/People/assets/18048754/b6bb79ac-3c08-4efe-b80c-b3b66a5d4bbd" width="60%" height="60%">
</p>

<br/>

---

### 4. RxSwift를 활용한 NotificationCenter

**문제점**

워크스페이스 정보 변경시 워크스페이스 리스트의 정보 업데이트를 위해 **NotificationCenter**를 활용하기로 함
하지만 **NotificationCenter** 구성을 위해서 **add, remove, post** 과정을 거쳐여하는 번거로움이 존재

**해결법**

**RxSwift**를 통해 **NotificationCenter**를 **add**와 **remove**를 사용하지 않고 사용할 수 있게 됨 

관찰하고자 하는 쪽에 **Notification**을 **Observable**로 구성하고

```swift
final class WorkspaceListViewModel: ViewModelType {
    ...
    
    //NotificationCenter
    **let notificationObservable = NotificationCenter.default.rx.notification(Notification.Name("EditComplete"))**
    
    ...
```

**Observable**이 변경될 때 필요한 작업을 동작한다

```swift
**notificationObservable**
    .flatMapLatest { _ in
        APIManager.shared.singleRequest(type: Workspaces.self, api: .getWorkspaceList)
    }
    .subscribe(with: self) { owner, result in
        switch result {
        case .success(let response):
            print("HomeView Get WorkspaceList Success",response)
            workspaceList.onNext(response)
        case .failure(let error):
            print("HomeView Get WorkspaceList Failure",error)
        }
    }
    .disposed(by: disposeBag)
```

변경을 알려줘야 하는 쪽에서는 **post**를 통해 변경이 일어났음을 알림

```swift
input.editWorkspaceButtonClicked
            .withLatestFrom(inputData)
            .flatMapLatest { name, description, image in
                return APIManager.shared.singleMultipartRequset(type: AddWorkspaceResponse.self, api: .editWorspace(id: input.workspace.workspaceID, model: AddWorkspaceRequest(name: name, description: description, image: image)))
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print("Edit Workspace Success", result)
                    **NotificationCenter.default.post(name: NSNotification.Name("EditComplete"), object: nil)**
                    owner.editSuccess?()
                case .failure(let error):
                    print("Edit Workspace Error")
                    print(error)
                }
                
            }
            .disposed(by: disposeBag)
```
