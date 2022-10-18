//
//  Product.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 29/06/2021.
//

import Foundation


struct BarcodeResponse: Codable {
    let data: [Product]?
    let relatedProducts: [Product]?
    enum CodingKeys: String, CodingKey {
        case data
        case relatedProducts = "related_products"
    }
}

struct ProductResponse: Codable {
    let data: Product?
    let relatedProducts: [Product]?
    enum CodingKeys: String, CodingKey {
        case data
        case relatedProducts = "related_products"
    }
}
struct Product: Codable {
    let id, name, productDescription: String?
    let onSale, regularPrice, hotPrice: String?
    let discountPrice, barcode, priceUnit, inStock: String?
    let categoryID: Int?
    let quantity: Double?
    let images:[ImageModel]
    let liked: Bool?
    let total: Double? // returns in get cart api
    let weight: String? // returns in get cart api

    enum CodingKeys: String, CodingKey {
        case id, name, images, barcode, liked, total, quantity, weight
        case productDescription = "description"
        case onSale = "on_sale"
        case regularPrice = "regular_price"
        case hotPrice = "hot_price"
        case discountPrice = "discountprice"
        case priceUnit = "PriceUnit"
        case inStock = "in_stock"
        case categoryID = "category_id"
    }
}
