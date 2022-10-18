//
//  OffersResponse.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import Foundation

struct Offer: Codable {
    let products: [Product]?
    let offerName: String?
    let offerId: String?
    
    private enum CodingKeys: String, CodingKey {
        case products
        case offerName = "offer_name"
        case offerId = "offer_id"
    }
}
