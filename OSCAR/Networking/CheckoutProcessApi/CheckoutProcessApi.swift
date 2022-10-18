//
//  CartNetworking.swift
//  OSCAR
//
//  Created by Mostafa Samir on 03/08/2021.
//

import Alamofire

enum CheckoutProcessPaths {
    static let getCart = "get_cart_new/"
    static let addToCart = "add_cart"
    static let removeFromCart = "remove_cart"
    static let getDeliverFees = "get_paid_types_new/en"
    static let validateVoucher = "validate_voucher"
    
}

enum CheckoutProcessApi: Requestable {
    
    case getCart
    case addToCart(parameters: AddToCartParameters)
    case removeFromCart(productId: String)
    case getDeliveryFees(coordinates: String)
    case validateVoucher(name: String)
    
    var path: String {
        switch self {
        case .getCart:
            return CheckoutProcessPaths.getCart + ((LanguageManager.shared.getCurrentLanguage() ?? "en")) +
           "?store_id=\(CurrentUser.shared.store)"
        case .addToCart:
            return CheckoutProcessPaths.addToCart
        case .removeFromCart:
            return CheckoutProcessPaths.removeFromCart
        case .getDeliveryFees:
            return CheckoutProcessPaths.getDeliverFees
        case .validateVoucher:
            return CheckoutProcessPaths.validateVoucher
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCart:
            return .get
        case .addToCart:
            return .post
        case .removeFromCart:
            return .post
        case .getDeliveryFees:
            return .post
        case .validateVoucher:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getCart:
            return nil
        case .addToCart(let parameters):
            return parameters.getParamsAsJson()
        case .removeFromCart(let productId):
            return ["product_id": productId]
        case .getDeliveryFees(let coordinates):
            return ["coordinates": coordinates]
        case .validateVoucher(let name):
            return ["name": name,
                    "lang": (LanguageManager.shared.getCurrentLanguage() ?? "en")
            ]
        }
    }
    
    var isWWWFormUrlEncoded: Bool? {
        switch self {
        case .getDeliveryFees:
            return true
        default:
            return false
        }
    }
}
