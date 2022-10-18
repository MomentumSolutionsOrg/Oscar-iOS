//
//  Order.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import Foundation

struct Order: Codable {
    let id: Int?
    let orderNumber, customerAddress, customerAccount: String?
    let signature: Int?
    let notesPeriod, logistaUserID, logistaOrderID, createdAt: String?
    let updatedAt: String?
    let customerID: Int?
    let customerPhone: String?
    let expressShipping: Int?
    let orderStatus: String?
    let deliveryFees: String?
    let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case id, products
        case orderNumber = "OrderNumber"
        case customerAddress = "CustomerAddress"
        case customerAccount = "CustomerAccount"
        case signature = "Signature"
        case notesPeriod = "NotesPeriod"
        case logistaUserID = "logista_user_id"
        case logistaOrderID = "logista_order_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case customerID = "customer_id"
        case customerPhone = "CustomerPhone"
        case expressShipping = "express_shipping"
        case orderStatus = "order_status"
        case deliveryFees = "deliver_fee"
    }
}
