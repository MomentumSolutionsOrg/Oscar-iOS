//
//  Product.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 29/06/2021.
//

import Foundation


struct BarcodeResponse: Codable {
    let data: Product?
    let relatedProducts: [Product]?
    enum CodingKeys: String, CodingKey {
        case data
        case relatedProducts = "related_products"
    }
}



struct ProductResponse: Codable {
    let message: String?
    let data: Product?
    let relatedProducts: [Product]?
    enum CodingKeys: String, CodingKey {
        case message
        case data
        case relatedProducts = "related_products"
    }
}



//struct Product: Codable {
//    let id, name, productDescription: String?
//    let onSale, regularPrice, hotPrice: String?
//    let discountPrice, barcode, priceUnit, inStock: String?
//    let categoryID: Int?
//    let quantity: Double?
//    let images:[ImageModel]
//    let liked: Bool?
//    let total: Double? // returns in get cart api
//    let weight: String? // returns in get cart api
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, images, barcode, liked, total, quantity, weight
//        case productDescription = "description"
//        case onSale = "on_sale"
//        case regularPrice = "regular_price"
//        case hotPrice = "hot_price"
//        case discountPrice = "discountprice"
//        case priceUnit = "PriceUnit"
//        case inStock = "in_stock"
//        case categoryID = "category_id"
//    }
//}



// MARK: - Datum
struct Product: Codable {
    let id, idERP, productcategoryID: Int?
    let name, nameAr, taxrate, productDES: String?
    let descriptionAr: String?
    let keywords: String?
    let subCatID, brandID, ins: Int?
    let inStock: Int?
    let createdAt, updatedAt: String?
    let featured: Int?
    let productID: String?
    let storeID: String?
    let available: Int?
    let description: String?
    let liked: Bool?
    let unit: String?
    let cart: Int?
    let category: String?
    let standard: Standard
    
    func images() -> [String] {
        if let image = standard.image {
            return [image]
        } else {
            return []
        }
        
    }


    enum CodingKeys: String, CodingKey {
        case id
        case idERP = "id_erp"
        case productcategoryID = "productcategory_id"
        case name
        case nameAr = "name_ar"
        case taxrate
        case inStock = "in_stock"
        case productDES = "product_des"
        case descriptionAr = "description_ar"
        case keywords
        case subCatID = "sub_cat_id"
        case brandID = "brand_id"
        case ins
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case featured
        case productID = "product_id"
        case storeID = "store_id"
        case available, description, liked, cart, category, standard
        case unit
    }
}


// MARK: - Standard
struct Standard: Codable {
    let id, productID, parentID, variationClass: Int?
    let name: String?
    let warehouseID: Int?
    let code: String?
    let price: Double?
    let purchasePrice, disrate, quantity: String?
    let alert: String?
    let image: String?
    let barcode: String?
    let expiry: String?
    let ins: Int?
    let createdAt, updatedAt: String?
    let onSale: Int?
    let discountPrice: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case parentID = "parent_id"
        case variationClass = "variation_class"
        case name
        case warehouseID = "warehouse_id"
        case code, price
        case purchasePrice = "purchase_price"
        case quantity = "qty"
        case disrate, alert, image, barcode, expiry, ins
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case onSale = "discount_flag"
        case discountPrice = "discount_price"
    }
}



extension Double {
    /// Converts a Double into a formatted currency string, device's current Locale.
    var currency: String {
        return String(format: "%.02f", self)
    }
}
