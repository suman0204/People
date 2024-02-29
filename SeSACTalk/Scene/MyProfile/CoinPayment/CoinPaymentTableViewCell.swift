//
//  CoinPaymentTableViewCell.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/29.
//

import UIKit
import RxSwift

final class CoinPaymentTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    
    let payButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: Typography.Title2.size, weight: Typography.Title2.weight)
        button.setTitleColor(Colors.BrandColor.white, for: .normal)
        button.backgroundColor = Colors.BrandColor.green
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureCell() {
        self.textLabel?.text = "현재 보유한 코인 300개"
        self.textLabel?.font = .systemFont(ofSize: Typography.BodyBlod.size, weight: Typography.BodyBlod.weight)
        
        self.detailTextLabel?.text = "코인이란?"
        self.detailTextLabel?.textColor = Colors.TextColor.secondary
        self.detailTextLabel?.font = .systemFont(ofSize: Typography.Body.size, weight: Typography.Body.weight)
        
        contentView.backgroundColor = Colors.BackgroundColor.secondary
        
    }
    
    func setData(data: CoinData) {
        if data.attribute {
            self.textLabel?.textColor = Colors.BrandColor.green
            let attributed = NSMutableAttributedString(string: data.title)
            attributed.addAttribute(.foregroundColor, value: Colors.TextColor.primary, range: (data.title as NSString).range(of: "현재 보유한 코인"))
            
            self.textLabel?.attributedText = attributed
        } else {
            self.textLabel?.textColor = Colors.TextColor.primary
            self.textLabel?.text = data.title
        }
        
        self.detailTextLabel?.text = data.detail
        
        if data.accessoryView {
            
            guard let coinPrice = data.coinPrice else {return}
            print(coinPrice)
            
            payButton.setTitle("₩\(String(describing: coinPrice))", for: .normal)
            payButton.frame = CGRect(x: 0, y: 0, width: 74, height: 28)
            self.accessoryView = payButton
        }
    }
}

struct CoinData {
    var title: String
    var detail: String?
    var attribute: Bool
    var accessoryView: Bool
    var coinPrice: Int?
}

struct CoinTableData {
    var first: [CoinData]
    var second: [CoinData]
}
