//
//  Interceptor.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/24.
//

import Foundation
import Alamofire
import RxSwift

final class Interceptor: RequestInterceptor {
    
    static let shared = Interceptor()
    
    private init() { }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("Enter Adapt")
        
        guard let path = urlRequest.url?.path(percentEncoded: true) else { return }
        print(path)
        
        guard urlRequest.url?.absoluteString.hasPrefix(APIKey.baseURL) == true, let accessToken = KeychainManager.shared.read(account: .accessToken) else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
        
//        guard let path = urlRequest.url?.path(percentEncoded: true) else { return }
//        print(path)
//        
//        guard urlRequest.url?.absoluteString.hasPrefix(APIKey.baseURL) == true, ["/validation", "/join", "/login"].contains(path) == false else {
//            completion(.success(urlRequest))
//            return
//        }
////        
//        guard let accessToken = KeychainManager.shared.read(account: .accessToken), let refreshToken = KeychainManager.shared.read(account: .refreshToken) else { return }
////
//        var urlRequest = urlRequest
//        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
//        
//        if ["/auth/refresh"].contains(path) {
//            print("Refresh")
//            urlRequest.setValue(refreshToken, forHTTPHeaderField: "RefreshToken")
//        }
//        
//        print("adapt header", urlRequest.headers)
//        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
//        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("Enter Retry", error)
        
        guard let refreshToken = KeychainManager.shared.read(account: .refreshToken) else { return }
        
        APIManager.shared.refreshRequest(type: RefreshResponse.self, api: .refresh) { response in
            print("Retry Response ---", response)
            switch response {
            case .success(let success):
                print("Refresh Success ---", success.accessToken)
                KeychainManager.shared.create(account: .accessToken, value: success.accessToken)
                
//                SwitchView.shared.switchView(viewController: TabBarController())
                completion(.retry)
            case .failure(let failure):
                print("Refresh Failure ---", failure.rawValue, failure.description)
                
                let refreshError = ["E06", "E02", "E03"]
                
                if refreshError.contains(failure.rawValue) {
                    
                    SwitchView.shared.switchView(viewController: OnboardingViewController())
                }
                
                
                completion(.doNotRetryWithError(failure))
            }
        }
        
//        guard let response = request.task?.response as? HTTPURLResponse, response.sta
    }
}
