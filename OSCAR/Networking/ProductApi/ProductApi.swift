//
//  ProductApi.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 05/07/2021.
//

import Alamofire

enum ProductPaths {
    static let barcode = "barcode"
    static let showProduct = "show_product/"
    
}

enum ProductApi: Requestable {
    
    case barcode(barcode:String)
    case showProduct(id:String)
    
    var path: String {
        switch self {
        case .barcode(let barcode):
            return ProductPaths.barcode + "?barcode=" + barcode + "&" + NetworkConstants.storeLangPath
        case .showProduct(let id):

            return ProductPaths.showProduct + id + "?" + NetworkConstants.storeLangPath
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
