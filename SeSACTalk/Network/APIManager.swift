//
//  APIManager.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/12.
//

import Foundation
import Alamofire
//import Moya
import RxSwift

final class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func request<T: Decodable>(type: T.Type, api: Router, completion: @escaping (Result<T, CommonError>) -> Void) {
        
        AF.request(api, interceptor: Interceptor.shared).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                print("APIManager request", data)
                completion(.success(data))
            case .failure(let error):
                print("APIManager error", error)
                
                guard let responseData = response.data else {
                    completion(.failure(CommonError.unknownError))
                    return
                }
                
                do {
                    let networkError = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                    let errorCode = networkError.errorCode
                    let error = CommonError(rawValue: errorCode)
                    completion(.failure(error ?? CommonError.unknownError))
                }
                catch {
                    completion(.failure(CommonError.unknownError))
                }
                
            }
        }
    }
    
    func singleRequest<T: Decodable>(type: T.Type, api: Router) -> Single<Result<T, CommonError>> {
        return Single.create { [weak self] single in
            self?.request(type: T.self, api: api) { response in
                switch response {
                case .success(let success):
                    single(.success(.success(success)))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            
            return Disposables.create()
        }
    }

    
    func emailValidationRequest(api: Router) -> Single<Result<Any, CommonError>> {
        return Single.create { single in
            AF.request(api).validate(statusCode: 200..<300).response { response in
                switch response.result {
                case .success(let success):
                   print(success)
                    single(.success(.success(success)))
                case .failure(let failure):
                    print(failure)
                    single(.success(.failure(CommonError.unknownError)))
                }
            }
            
            return Disposables.create()
        }
    }
    

    func singleMultipartRequset<T: Decodable>(type: T.Type, api: Router) -> Single<Result<T, CommonError>> {
        return Single.create { single in
            AF.upload(multipartFormData: api.multipart, with: api, interceptor: Interceptor.shared).responseDecodable(of: T.self) { response in
                switch response.result {
                case.success(let result):
                    print("Multipart Result", result)
                    single(.success(.success(result)))
                case .failure(let error):
                    print("Multipart Error", error)
                    
                    guard let responseData = response.data else {
                        single(.failure(CommonError.unknownError))
                        return
                    }
                    
                    do {
                        let networkError = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                        let errorCode = networkError.errorCode
                        let error = CommonError(rawValue: errorCode)
                        single(.success(.failure(error ?? CommonError.unknownError)))
                    }
                    catch {
                        single(.failure(CommonError.unknownError))
                    }
                    
                }
            }
            
            return Disposables.create()
        }
    }

    func refreshRequest<T: Decodable>(
        type: T.Type,
        api: Router,
        completion: @escaping (Result<T, CommonError>) -> Void
    ) {
        AF.request(api)
            .validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
//                print("0000\(response)")
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    print(error)
                    if let data = response.data {
                        print(data)
                        do {
                            let networkError = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            let errorString = networkError.errorCode
                            let errorEnum = CommonError(rawValue: errorString) ?? CommonError.unknownError
                            completion(.failure(errorEnum))
                        }
                        catch {
                            completion(.failure(CommonError.unknownError))
                        }
                    }
                }
            }
    }
}


