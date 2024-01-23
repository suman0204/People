//
//  HomeHeaderView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/19.
//

import UIKit

final class HomeHeaderView: BaseView {
    
    let workspaceImage = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func configureView() {
        
    }
    
    override func setConstraints() {
        
    }
}
