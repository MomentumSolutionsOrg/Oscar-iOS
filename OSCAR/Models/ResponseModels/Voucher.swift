//
//  Vouchers.swift
//  OSCAR
//
//  Created by Mostafa Samir on 05/08/2021.
//

import Foundation

struct Voucher: Codable {
    let id: Int?
    let voucherType, from: String?
    let to: String?
    let discountNumber, noUsage: Int?
    let createdAt, updatedAt, name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case voucherType = "voucher_type"
        case from, to
        case discountNumber = "discount_number"
        case noUsage = "no_usage"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
    }
}
