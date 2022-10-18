//
//  DeliveryFees.swift
//  OSCAR
//
//  Created by Mostafa Samir on 11/08/2021.
//

import Foundation

struct DeliveryFees: Codable {
    let flag: String?
    let cost: String?
    let flagArabic: String
    private enum CodingKeys: String, CodingKey {
        case flag, cost
        case flagArabic = "flag_ar"
    }
}
