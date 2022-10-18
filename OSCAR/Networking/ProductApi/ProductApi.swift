//
//  ProductApi.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 05/07/2021.
//

import Alamofire

enum ProductPaths {
    static let barcode = "products?barcode="
    static let showProduct = "show_product_new/"
    
}

enum ProductApi: Requestable {
    
    case barcode(barcode:String)
    case showProduct(id:String)
    
    var path: String {
        switch self {
        case .barcode(let barcode):
            return ProductPaths.barcode + barcode
        case .showProduct(let id):
            return ProductPaths.showProduct + id + "/\((LanguageManager.shared.getCurrentLanguage() ?? "en"))?store_id=\(CurrentUser.shared.store)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .barcode:
            return .get
        case .showProduct:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
}
