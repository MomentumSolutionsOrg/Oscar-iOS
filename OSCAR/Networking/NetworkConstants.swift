//
//  NetworkConstants.swift
//  OSCAR
//
//  Created by Mostafa Samir on 9/8/20.
//

import Foundation
enum NetworkConstants {
    
    /// Base URLs
    static let baseURL = "http://34.105.27.34/oscarnewapis/public/api/"
    static let removeAccountURL = "https://cms.oscarstoresapp.com/remove-account"
    //static let imageBaseUrl = "https://oscar.momentum-sol.com/"
    static var storeLangPath:String  {
        return "store_id=\(CurrentUser.shared.store)&lang=\((LanguageManager.shared.getCurrentLanguage() ?? "en"))"
    }
    
    /// The keys for HTTP header fields
    enum HTTPHeaderFieldKey: String {
        case authorization = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case string = "String"
    }
    
    /// The values for HTTP header fields
    enum HTTPHeaderFieldValue: String {
        case json = "application/json"
        case html = "text/html"
        case formEncode = "application/x-www-form-urlencoded"
        case accept = "*/*"
    }
}
