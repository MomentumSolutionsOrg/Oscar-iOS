//
//  Branch.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 04/07/2021.
//

import Foundation

// MARK: - User
struct Branch: Codable {
    let id: Int?
    let title: String?
    let km: Double?
    let image: String?
    let logo: String?
    let headerLogo: String?
    let category, status: String?
    let location: String?
    let storeID: String?
    let hide, showPrices: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, km, image, logo
        case headerLogo = "header_logo"
        case category, status, location
        case storeID = "store_id"
        case hide
        case showPrices = "show_prices"
    }
}

