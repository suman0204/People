//
//  Extension + UIImageView.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/01.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(from url: String, placeHolderImage: UIImage = UIImage(named: "workspace")!) {
        let modifier = AnyModifier { request in
            var request = request
            if let accessToken = KeychainManager.shared.read(account: .accessToken) {
                request.setValue(accessToken, forHTTPHeaderField: "Authorization")
                request.setValue(APIKey.SeSACKey, forHTTPHeaderField: "SesacKey")
            }
            return request
        }
        
        let url = URL(string: "\(APIKey.baseURL)/v1\(url)")!
//        let url = URL(string: APIKey.testURL + url)!
        
        self.kf.setImage(with: url, placeholder: placeHolderImage, options: [.requestModifier(modifier), .forceRefresh])
    }
}
