//
//  WishListApi.swift
//  OSCAR
//
//  Created by Mostafa Samir on 03/08/2021.
//

import Alamofire

enum WishListPaths {
    static let getWishList = "get_wishlist/"
    static let addToWishList = "add/wishlist/"
    static let removeFromWishList = "remove/wishlist"
    static let addSelectedToCart = "add_cart_form_wish"
}

enum WishListApi: Requestable {
    
    case getWishList
    case addToWishList(productId: String)
    case removeFromWishList(productIds: [String])
    case addSelectedToCart([String])
    
    var path: String {
        switch self {
        case .getWishList:
            return WishListPaths.getWishList + (LanguageManager.shared.getCurrentLanguage() ?? "en") +
            "?store_id=\(CurrentUser.shared.store)"
        case .addToWishList(let productId):
            return WishListPaths.addToWishList + productId
        case .removeFromWishList:
            return WishListPaths.removeFromWishList
        case .addSelectedToCart:
            return WishListPaths.addSelectedToCart
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWishList:
            return .get
        case .addToWishList:
            return .post
        case .removeFromWishList:
            return .post
        case .addSelectedToCart:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .removeFromWishList(let productIds):
            return ["id": productIds]
        case .addSelectedToCart(let itemsIds):
            return ["id": itemsIds]
        default:
        return nil
        }
    }
}
