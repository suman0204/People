////
////  Router.swift
////  SeSACTalk
////
////  Created by 홍수만 on 2024/01/11.
////
//
import Foundation
//import Moya

//enum API {
//    case emailValidation(model: EmailValidation)
//    case signUp(model: SignUp)
//    case logIn(model:LogIn)
//}
//
//extension API: TargetType {
//    var baseURL: URL {
//        return URL(string: APIKey.baseURL)!
//    }
//    
//    var path: String {
//        switch self {
//        case .emailValidation:
//            return "/v1/users/validation/email"
//        case .signUp:
//            return "/v1/users/join"
//        case .logIn:
//            return "/v2/users/login"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//        case .emailValidation, .signUp, .logIn:
//            return .post
//        }
//    }
//    
//    var task: Moya.Task {
//        switch self {
//        case .emailValidation(let model):
//            return .requestJSONEncodable(model)
//        case .signUp(let model):
//            return .requestJSONEncodable(model)
//        case .logIn(let model):
//            return .requestJSONEncodable(model)
//        }
//    }
//    
//    var headers: [String : String]? {
//        switch self {
//        case .emailValidation, .signUp, .logIn:
//            return ["Content-Type" : "application/json",
//                    "SesacKey": APIKey.SeSACKey]
//        }
//    }
//    
//    var validationType: ValidationType {
//        return .successCodes
//    }
//}

import Alamofire

enum Router: URLRequestConvertible {

    case emailValidation(model: EmailValidationRequest)
    case signUp(model: SignUpRequest)
    case logIn(model: LogInRequest)
    case addWorkspace(model: AddWorkspaceRequest)

    private var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }

    private var path: String {
        switch self {
        case .emailValidation:
            return "v1/users/validation/email"
        case .signUp:
            return "v1/users/join"
        case .logIn:
            return "v2/users/login"
        case .addWorkspace:
            return "v1/workspaces"
        }
    }

    private var header: HTTPHeaders {
        switch self {
        case .emailValidation, .signUp, .logIn:
            return ["Content-Type" : "application/json",
                    "SesacKey": APIKey.SeSACKey]
        case .addWorkspace:
            return ["Content-Type" : "multipart/form-data",
                    "Authorization": KeychainManager.shared.read(account: "token") ?? "",
                    "SesacKey": APIKey.SeSACKey]
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .emailValidation, .signUp, .logIn, .addWorkspace:
            return .post
        }
    }
    
    private var paramters: Parameters? {
        switch self {
        case .emailValidation(let model):
            return ["email": model.email]
        case .signUp(let model):
            return ["email": model.email, "nickname": model.nickname, "phone": model.phone ?? "","password": model.password]
        case .logIn(let model):
            return ["email": model.email, "password": model.password, "deviceToken": model.deviceToken]
        default:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = header
        
        switch method {
        case .get:
            return try URLEncoding.default.encode(request, with: paramters)
        default:
            request = try JSONEncoding.default.encode(request, with: paramters)
            return request
        }
    }


}

extension Router {
    var multipart: MultipartFormData {
        switch self {
        case .addWorkspace(let model):
            let multipartFormData = MultipartFormData()
            
            let name = model.name.data(using: .utf8) ?? Data()
            let description = model.description?.data(using: .utf8) ?? Data()
            let image = model.image
            
            multipartFormData.append(name, withName: "name")
            multipartFormData.append(description, withName: "description")
            multipartFormData.append(image, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            
            return multipartFormData
            
        default :
            return MultipartFormData()
        }
    }
}
