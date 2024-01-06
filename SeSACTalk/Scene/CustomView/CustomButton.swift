//
//  CustomButton.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/03.
//

import UIKit

class CustomButton: UIButton {
    
    init(title: String?, setbackgroundColor: UIColor?) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(Colors.BrandColor.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        backgroundColor = setbackgroundColor
        layer.cornerRadius = 8
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
