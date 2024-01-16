//
//  Extension+UIViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/11.
//

import UIKit
import SnapKit

extension UIViewController {
    
    func showToast(message: String) {
        // 최대 width를 설정하거나 필요에 따라 조절합니다.
        let maxWidth: CGFloat = 300.0
        
        // 메시지에 맞게 label의 크기를 조절합니다.
        let label = UILabel()
        label.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = Colors.BrandColor.green
        label.textColor = Colors.BrandColor.white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        
        let maxSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let expectedSize = label.sizeThatFits(maxSize)
        label.frame.size = CGSize(width: min(expectedSize.width + 16, maxWidth), height: expectedSize.height + 10)
        
        label.frame.origin = CGPoint(
            x: self.view.frame.size.width / 2 - label.frame.size.width / 2,
            y: self.view.frame.size.height - 160
        )
        
        self.view.addSubview(label)
        
        UIView.animate(withDuration: 2.5, delay: 0.1, options: .curveEaseOut, animations: {
            label.alpha = 0.0
        }, completion: { _ in
            label.removeFromSuperview()
        })
    }

//    func showToast(message : String) {
//        let toastLabel = UILabel(frame: .zero)
//        toastLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
//        }
//            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//            toastLabel.textColor = UIColor.white
//            toastLabel.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
//            toastLabel.textAlignment = .center;
//            toastLabel.text = message
//            toastLabel.alpha = 1.0
//            toastLabel.layer.cornerRadius = 8
//            toastLabel.clipsToBounds  =  true
//            self.view.addSubview(toastLabel)
//            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//                 toastLabel.alpha = 0.0
//            }, completion: {(isCompleted) in
//                toastLabel.removeFromSuperview()
//            })
//        }
    
//    func showToast(message: String) {
////        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
////           let window = windowScene.windows.first {
////            // 여기에서 window를 사용합니다.
////        }
//        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
//            return
//        }
//        
//        let toastLabel = UILabel()
//        toastLabel.text = message
//        toastLabel.textAlignment = .center
//        toastLabel.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
//        toastLabel.textColor = Colors.BrandColor.white
//        toastLabel.backgroundColor = Colors.BrandColor.green
//        toastLabel.numberOfLines = 0
//        
//        let textSize = toastLabel.intrinsicContentSize
//        let labelWidth = min(textSize.w)
//    }
}
