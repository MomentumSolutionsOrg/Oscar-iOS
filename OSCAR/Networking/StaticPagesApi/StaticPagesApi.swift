//
//  StaticPagesApi.swift
//  OSCAR
//
//  Created by Mostafa Samir on 07/09/2021.
//

import Alamofire

enum StaticPagesPaths {
    static let aboutUs = "about_us"
}

enum StaticPagesApi: Requestable {
    
    case aboutUs
    
    var path: String {
        switch self {
        case .aboutUs:
            return StaticPagesPaths.aboutUs
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}
