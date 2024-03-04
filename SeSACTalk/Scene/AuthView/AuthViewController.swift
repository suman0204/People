//
//  AuthViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/03.
//

import UIKit
import AuthenticationServices
import RxSwift


final class AuthViewController: BaseViewController {
    
    let viewModel = AuthViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy var appleLoginButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AppleIDLogin"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFill
//        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(appleLoginButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let kakaoLoginButton = {
        let button = CustomButton(title: nil, setbackgroundColor: nil)
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        return button
    }()
    
    lazy var emailLoginButton = {
        let button = CustomButton(title: nil, setbackgroundColor: nil)
        button.setImage(UIImage(named: "EmailLogin"), for: .normal)
        button.addTarget(self, action: #selector(emailLogInButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpButton = {
        let title = "또는 새롭게 회원가입 하기"
        let customTitle = NSMutableAttributedString(string: title)
        customTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 2))
        let button = UIButton()
        button.setTitleColor(Colors.BrandColor.green, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        button.setAttributedTitle(customTitle, for: .normal)

        button.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func bind() {
        let input = AuthViewModel.Input(kakaoLoginButtonClicked: kakaoLoginButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
    }
    
    @objc
    func signUpButtonClicked() {
        let vc = SignUpViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [
                .large()
            ]
            
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
    
    @objc
    func emailLogInButtonClicked() {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [
                .large()
            ]
            
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
    
    @objc
    func appleLoginButtonClicked() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [appleLoginButton, kakaoLoginButton, emailLoginButton, signUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(22)
        }
    }
    
}


extension AuthViewController: ASAuthorizationControllerDelegate {
    
    //애플 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Login Falied", error.localizedDescription)
    }
    
    //애플 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print(appleIDCredential)
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            guard let token = appleIDCredential.identityToken, let tokenToString = String(data: token, encoding: .utf8) else {
                print("Token Error")
                return
            }
            
            print(userIdentifier)
            print(fullName ?? "NO FullName")
            print(email ?? "No Email")
            print(tokenToString)
            
            KeychainManager.shared.create(account: .appleLogInEmail, value: email ?? "")
            KeychainManager.shared.create(account: .appleLogInName, value: fullName?.givenName ?? "")
            KeychainManager.shared.create(account: .appleLogInidToken, value: tokenToString)
            
            APIManager.shared.request(type: LogInResponse.self, api: .appleLogin(model: AppleLogInRequest(idToken: tokenToString, nickname: fullName?.givenName ?? "", deviceToken: ""))) { result in
                switch result {
                case .success(let success):
                    print(success)
                    KeychainManager.shared.create(account: .accessToken, value: success.token.accessToken)
                    KeychainManager.shared.create(account: .refreshToken, value: success.token.refreshToken)
                    KeychainManager.shared.create(account: .userID, value: "\(success.user_id)")
                    self.switchMain()
                case .failure(let failure):
                    print(failure)
                }
            }
            
        case let passwordCredential as ASPasswordCredential:
            
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print(username, password)
            
        default: break
        }
        
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension AuthViewController {
    
    func switchMain() {
        APIManager.shared.request(type: Workspaces.self, api: .getWorkspaceList) { result in
            switch result {
            case .success(let response):
                print("LoginViewModel Get Workspace Succes", response)
                if response.count > 0 {
                    SwitchView.shared.switchView(viewController: TabBarController())
                } else {
                    SwitchView.shared.switchView(viewController: HomeViewController(homeState: .empty))
                }
            case .failure(let error):
                print("LoginViewModel Get Workspace Failure", error)
                SwitchView.shared.switchView(viewController: OnboardingViewController())
            }
        }
    }
}
