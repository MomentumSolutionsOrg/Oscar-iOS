//
//  OffersNetworking.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//


import Alamofire

enum OffersPaths {
    static let offers = "offers"
    static let vouchers = "vouchers/"
    static let offerProducts = "offers/"
    
}

enum OffersApi: Requestable {
    
    case getOffers
    case getVouchers
    case getOfferProducts(name: String)
    
    var path: String {
        switch self {
        case .getOffers:
            return OffersPaths.offers
        case .getVouchers:
            return OffersPaths.vouchers + (LanguageManager.shared.getCurrentLanguage() ?? "en")
        case .getOfferProducts(let name):
            return OffersPaths.offerProducts + name
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getOffers:
            return .post
        case .getVouchers:
            return .get
        case .getOfferProducts:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getOffers:
            return ["paginate": 10,
                    "store_id": CurrentUser.shared.store,
                    "lang": LanguageManager.shared.getCurrentLanguage() ?? "en"]
        case .getVouchers:
            return nil
        case .getOfferProducts:
            return [ "store_id": CurrentUser.shared.store,
                    "lang": (LanguageManager.shared.getCurrentLanguage() ?? "en")
            ]
        }
    }
}
