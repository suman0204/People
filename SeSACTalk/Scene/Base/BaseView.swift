//
//  BaseView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/06.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        
    }
    
    func setConstraints() {
        
    }
}
