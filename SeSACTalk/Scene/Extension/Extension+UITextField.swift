//
//  Extension+UITextField.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/08.
//

import UIKit

//textField Placeholder padding
extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
