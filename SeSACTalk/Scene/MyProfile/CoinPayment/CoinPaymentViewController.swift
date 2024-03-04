//
//  CoinPaymentViewController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/02/29.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import iamport_ios

final class CoinPaymentViewController: BaseViewController {
    
    let viewModel = CoinPaymentViewModel()
    
    lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = Colors.BackgroundColor.primary
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(CoinPaymentTableViewCell.self, forCellReuseIdentifier: CoinPaymentTableViewCell.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        title = "코인샵"
        view.backgroundColor = Colors.BackgroundColor.primary
        
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}


extension CoinPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinPaymentTableViewCell.reuseIdentifier, for: indexPath) as? CoinPaymentTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let data = viewModel.cointData.first[indexPath.row]
            cell.setData(data: data)
            return cell
        } else {
            let data = viewModel.cointData.second[indexPath.row]
            cell.setData(data: data)
            cell.payButton.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
            return cell
        }
        
    }

}

extension CoinPaymentViewController {
    
    @objc
    func payButtonClicked(_ sender: UIButton) {
        print("payButton")
        
        //WebView
        setupWebView()
        
        //결제 데이터 구성
        let paymentData = createPaymentData(buttonTitle: sender.titleLabel?.text)
        
        //결제 요청
        Iamport.shared.paymentWebView(webViewMode: wkWebView,
                                      userCode: "imp57573124", payment: paymentData) { [weak self] iamportResponse in
            print("결제 요청!!")
            print(String(describing: iamportResponse))
            
            self?.removeWkWebView()
            
            if iamportResponse?.success == true {
                print("결제 성공")
                self?.endPaymend(response: iamportResponse)
            }
            
        }
    }
}

extension CoinPaymentViewController {
    
    //Payment WebView
    private func setupWebView() {
        view.addSubview(wkWebView)
        
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        
    }
    
    // 결제 요청 데이터 생성
    private func createPaymentData(buttonTitle: String?) -> IamportPayment {
        
        var amount = ""
        var coin = 10
        
        if let buttonTitle {
            amount = buttonTitle.replacingOccurrences(of: "₩", with: "")
            coin = (Int(amount) ?? 10) / 10
            print("Amount Coin", amount)
        } else {
            print("NOOO ButtonTitle")
        }
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(APIKey.SeSACKey)_\(Int(Date().timeIntervalSince1970))",
            amount: amount).then {
                $0.pay_method = PayMethod.card.rawValue
                                $0.name = "\(coin) Coin"
                                $0.buyer_name = "홍수만"
                                $0.app_scheme = "sesac"
            }
        
        return payment
    }
    
    //결제 종료 콜백
    private func endPaymend(response: IamportResponse?) {
        
        //서버에 유효성 검증
        guard let response = response else {return}
        
        APIManager.shared.request(type: PayValid.self, api: .postPayValid(model: PayValidRequest(imp_uid: response.imp_uid ?? "", merchant_uid: response.merchant_uid ?? ""))) { result in
            switch result {
            case .success(let response):
                print("PayValid Success")
                print(response)
                
                self.showToast(message: "\(response.sesacCoin) Coin이 결제되었습니다")
            case .failure(let error):
                print("PayValid Faliure")
                print(error)
            }
        }
    }
    
    //웹뷰 종료
    private func removeWkWebView() {
        view.willRemoveSubview(wkWebView)
        wkWebView.stopLoading()
        wkWebView.removeFromSuperview()
    }
}

