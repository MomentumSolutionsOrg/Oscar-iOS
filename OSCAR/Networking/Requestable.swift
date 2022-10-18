//
//  Requestable.swift
//  OSCAR
//
//  Created by Mostafa Samir on 9/9/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import Foundation
import Alamofire

protocol Requestable: URLRequestConvertible {
    var method: Alamofire.HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var header: [String: String]? { get }
    var isWWWFormUrlEncoded: Bool? { get }
    var queryParameters: String? { get }
    var urlParameters: Parameters? { get }
    var multipart: Alamofire.MultipartFormData? {get}
}

extension Requestable {
    // method is post by default 🙄
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var baseURL: String {
        return NetworkConstants.baseURL
    }
    
    // just to add nil as default parameter
    var parameters: Parameters? {
        return nil
    }
    
    var header:[String:String]? {
        return nil
    }
    
    var isWWWFormUrlEncoded: Bool? {
        return false
    }
    var queryParameters: String? {
        return nil
    }
    var urlParameters: Parameters? {
        return nil
    }
    
    var multipart: Alamofire.MultipartFormData? {
        return nil
    }
    
    // MARK: - Methods
    func asURLRequest() throws -> URLRequest {
        // Construct url
        let urlPath = baseURL + path
        
        guard var url = URL(string : urlPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? urlPath) else { throw MyError.badAPIRequest }
        
        if let extraParams = queryParameters {
            url = url.appendingPathComponent(extraParams)
        }
        
        var urlRequest = try URLRequest(url: url, method: method)
        debugPrint("****************** url :" + url.absoluteString)
        if let token = CurrentUser.shared.token, token != "" {
            print("****************** token :" + token)
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        // Set common headers
        if header != nil {
            for (key, value) in header! {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        switch method {
        case .get:
            let urlRequest = try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
            return urlRequest
        default:
            if isWWWFormUrlEncoded ?? false {
                let urlRequest = try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
                return urlRequest
            } else {
                let urlRequest = try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
                let request = try Alamofire.URLEncoding.default.encode(urlRequest, with: urlParameters)
                return request
            }
        }
    }
    
    func handleMultipart( multipart: inout Alamofire.MultipartFormData, parameters: RequestParameters){
        
        for (key,value) in parameters.getParamsAsJson()  {
            if let value = value as? String {
                multipart.append((value).data(using: .utf8)!, withName: key)
            } else if let value = value as? [String] {
                for string in value {
                    multipart.append(string.data(using: .utf8)!,withName: "\(key)[]")
                }
            }
        }
    }
}
