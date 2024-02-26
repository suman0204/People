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
    case refresh
    case addWorkspace(model: AddWorkspaceRequest)
    case getWorkspaceList
    case getOneWorkspace(id: Int)
    case getMyProfile
    case getMyChannels(id: Int)
    case getWorkspaceDMList(id: Int)
    case editWorspace(id: Int, model: AddWorkspaceRequest)
    case getWorkspaceMember(id: Int)
    case leaveWorkspace(id: Int)
    case postChannelChat(name: String, id: Int, model: ChannelChattingRequest)

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
        case .refresh:
            return "v1/auth/refresh"
        case .addWorkspace:
            return "v1/workspaces"
        case .getWorkspaceList:
            return "v1/workspaces"
        case .getOneWorkspace(let id):
            return "v1/workspaces/\(id)"
        case .getMyProfile:
            return "v1/users/my"
        case .getMyChannels(let id):
            return "v1/workspaces/\(id)/channels/my"
        case .getWorkspaceDMList(let id):
            return "v1/workspaces/\(id)/dms"
        case .editWorspace(let id, _):
            return "v1/workspaces/\(id)"
        case .getWorkspaceMember(let id):
            return "/v1/workspaces/\(id)/members"
        case .leaveWorkspace(let id):
            return "/v1/workspaces/\(id)/leave"
        case .postChannelChat(let name, let id, _):
            return "/v1/workspaces/\(id)/channels/\(name)/chats"
        }
    }

    private var header: HTTPHeaders {
        switch self {
        case .emailValidation, .signUp, .logIn:
            return ["Content-Type" : "application/json",
                    "SesacKey": APIKey.SeSACKey]
        case .refresh:
            return ["Content-Type" : "application/json",
                    "Authorization": KeychainManager.shared.read(account: .accessToken) ?? "",
                    "SesacKey": APIKey.SeSACKey,
                    "RefreshToken": KeychainManager.shared.read(account: .refreshToken) ?? ""]
        case .addWorkspace, .editWorspace, .postChannelChat:
            return ["Content-Type" : "multipart/form-data",
                    "Authorization": KeychainManager.shared.read(account: .accessToken) ?? "",
                    "SesacKey": APIKey.SeSACKey]
        case .getWorkspaceList, .getMyProfile, .getMyChannels, .getWorkspaceDMList, .getOneWorkspace, .getWorkspaceMember, .leaveWorkspace:
            return ["Content-Type" : "application/json",
                    "Authorization": KeychainManager.shared.read(account: .accessToken) ?? "",
                    "SesacKey": APIKey.SeSACKey]
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .emailValidation, .signUp, .logIn, .addWorkspace, .postChannelChat:
            return .post
        case .refresh, .getWorkspaceList, .getMyProfile, .getMyChannels, .getWorkspaceDMList, .getOneWorkspace, .getWorkspaceMember, .leaveWorkspace:
            return .get
        case .editWorspace:
            return .put
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
        case .addWorkspace(let model), .editWorspace(_, let model):
            let multipartFormData = MultipartFormData()
            
            let name = model.name.data(using: .utf8) ?? Data()
            let description = model.description?.data(using: .utf8) ?? Data()
            let image = model.image
            
            multipartFormData.append(name, withName: "name")
            multipartFormData.append(description, withName: "description")
            multipartFormData.append(image, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            
            return multipartFormData
            
        case .postChannelChat(_, _, let model):
            let multipartFormData = MultipartFormData()
            
            let content = model.content.data(using: .utf8) ?? Data()
            let files = model.files
            
            multipartFormData.append(content, withName: "content")
            
            for file in files {
                multipartFormData.append(file, withName: "files", fileName: "file.jpeg", mimeType: "image/jpeg")
            }
            
            return multipartFormData
            
        default :
            return MultipartFormData()
        }
    }
}
