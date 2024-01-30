//
//  LeftImageButton.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/30.
//

import UIKit

class LeftImageButton: UIButton {
    
    init(title: String?, imageName: String?) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.plain()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        titleContainer.foregroundColor = Colors.TextColor.secondary
        config.attributedTitle = AttributedString(title ?? "", attributes: titleContainer)
        
        config.image = UIImage(systemName: imageName ?? "")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 13)
        config.imagePadding = 10
        
        config.titleAlignment = .leading
        config.baseForegroundColor = Colors.TextColor.secondary
        
        self.configuration = config
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
