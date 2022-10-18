//
//  CategoriesApi.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import Alamofire

enum CategoriesPaths {
    static let categories = "categories_new"
    static let products = "products/"
    
}

enum CategoriesApi: Requestable {
    
    case getCategories
    case getProducts(categoryId:Int)
    
    var path: String {
        switch self {
        case .getCategories:
            return CategoriesPaths.categories + "?" + NetworkConstants.storeLangPath
        case .getProducts(let categoryId):
            return CategoriesPaths.products + categoryId.description + "?" + NetworkConstants.storeLangPath
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCategories:
            return .get
        case .getProducts:
            return .get
        }
    }
}
