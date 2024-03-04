//
//  OnboardingViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/02.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    
    // 뷰로 따로 빼기..
    let splashTextLabel = {
        let label = UILabel()
        label.text = "People을 사용하면 어디서나 \n 팀을 모을 수 있습니다"
        label.font = .systemFont(ofSize: Typography.Title1.size, weight: Typography.Title1.weight)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let splashImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "onboarding")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let startButton = CustomButton(title: "시작하기", setbackgroundColor: Colors.BrandColor.green)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OnboardingView Present")
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        //네비게이션 바 설정
//        let appearance = UINavigationBarAppearance()
//        appearance.shadowColor = .clear
//        appearance.backgroundColor = .white
//        
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.isHidden = true

        [splashTextLabel, splashImageView, startButton].forEach {
            view.addSubview($0)
        }
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    //AuthView sheet로 띄우기
    @objc
    func startButtonClicked() {
        let vc = AuthViewController()
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return 290
                })
            ]
            
            sheet.prefersGrabberVisible = true
        }
        
        present(vc, animated: true)
    }
    
    override func setConstraints() {
        splashTextLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(93)
            make.height.equalTo(60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerX.equalToSuperview()
            
        }
        
//        splashImageView.setContentCompressionResistancePriority(.init(rawValue: 750), for: .vertical)
        splashImageView.snp.makeConstraints { make in
//            make.top.equalTo(splashTextLabel.snp.bottom).offset(89)
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
//            make.height.equalTo(splashImageView.snp.width)
            make.center.equalToSuperview()
            make.horizontalEdges.greaterThanOrEqualToSuperview().inset(12)
            make.height.equalTo(splashImageView.snp.width)
            make.top.lessThanOrEqualTo(splashTextLabel.snp.bottom).offset(89)
            make.bottom.greaterThanOrEqualTo(startButton.snp.top).offset(-153)
        }
        
//        startButton.setContentCompressionResistancePriority(.init(751), for: .vertical)
        startButton.snp.makeConstraints { make in
//            make.top.lessThanOrEqualTo(splashImageView.snp.bottom).offset(153)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
            make.bottom.lessThanOrEqualToSuperview().offset(-45)
        }
    }
    
    
}
