//
//  AuthApi.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 29/06/2021.
//

import Alamofire

enum AuthPaths {
    static let login = "auth/login"
    static let signUp = "auth/register"
    static let logout = "auth/logout"
    static let forgetPass = "forget/password"
    static let userProfile = "auth/user-profile"
    static let updateProfile = "auth/update"
    static let contactUs = "contact_us"
    static let fcmToken = "devices/store_new"
}

enum AuthApi: Requestable {
    
    case login(LoginParams)
    case signUp(SignUpParams)
    case forgetPass(email:String)
    case logout
    case userProfile
    case updateProfile(parameters:UpdateProfileParameters)
    case contactUs(ContactUsParams)
    case fcmToken(token:String)
    
    var path: String {
        switch self {
        case .login:
            return AuthPaths.login
        case .signUp:
            return AuthPaths.signUp
        case .forgetPass:
            return AuthPaths.forgetPass
        case .logout:
            return AuthPaths.logout
        case .updateProfile:
            return AuthPaths.updateProfile
        case .contactUs(_):
            return AuthPaths.contactUs
        case .fcmToken:
            return AuthPaths.fcmToken
        case .userProfile:
            return AuthPaths.userProfile
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userProfile:
            return .get
        default:
            return .post
        }
    }
    
    var header: [String : String]? {
        switch self {
        case.updateProfile:
            return ["Accept":"application/json"]
        default:
            return nil
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let params):
            return params.getParamsAsJson()
        case .signUp(let params):
            return params.getParamsAsJson()
        case .forgetPass(email: let email):
            return ["email":email,
                    "lang": LanguageManager.shared.getCurrentLanguage() ?? "en"]
        case .logout:
            return nil
        case .updateProfile:
            return [:]
        case .contactUs(let parameters):
            return parameters.getParamsAsJson()
        case .fcmToken(token: let token):
            return ["device_token": token,"os":"ios", "language":"en"]
        case .userProfile:
            return nil
        }
    }
    
    var multipart: MultipartFormData? {
        switch self {
        case .updateProfile(let parameters):
            var multipart = Alamofire.MultipartFormData()
            if let image = parameters.image {
                multipart.append(image, withName: "image",fileName: "image")
            }
            
            handleMultipart(multipart: &multipart, parameters: parameters)
            return multipart
        default:
            return nil
        }
    }
}
