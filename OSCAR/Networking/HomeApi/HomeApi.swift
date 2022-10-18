//
//  HomeApi.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 29/06/2021.
//

import Alamofire

enum HomePaths {
    static let branches = "branches"
    static let search = "products?name="
    static let pinterest = "banners_pinterest"
//    static let banner1 = "banner_1"
//    static let banner2 = "banner_2"
    static let banners = "banners"
    static let filter = "product_new"
}

enum HomeApi: Requestable {
    case branches(long:Double,lat:Double)
    case branchesWithoutLocation
    case search(name:String)
    case filter(filters:FilterParameters)
    case banners
    case pinterest
    
    var path: String {
        switch self {
        case .branches(let long,let lat):
            return HomePaths.branches + "?latitudes=\(lat)&longitudes=\(long)&lang=\((LanguageManager.shared.getCurrentLanguage() ?? "en"))"
        case .search(let name):
            return HomePaths.search + name + "&" + NetworkConstants.storeLangPath
        case .branchesWithoutLocation:
            return HomePaths.branches + "?lang=\(LanguageManager.shared.getCurrentLanguage() ?? "en")"
        case .filter:
            return "products"
        case .banners:
            return HomePaths.banners
        case .pinterest:
            return HomePaths.pinterest
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .branches, .search,.branchesWithoutLocation,.banners:
            return .get
        case .filter:
            return .post
        case .pinterest:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .filter(let filters):
            return filters.getParamsAsJson()
        default:
            return nil
        }
    }
}
