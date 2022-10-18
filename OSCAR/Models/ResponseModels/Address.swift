//
//  Address.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import Foundation

struct Address: Codable {
    let id: Int?
    let name, address, area, city: String?
    let phone: String?
    let isDefault: Int?
    let customerID: Int?
    let createdAt, updatedAt, coordinates, buildingNumber: String?
    let floorNumber, apartmentNumber: String?

    enum CodingKeys: String, CodingKey {
        case id, name, address, area, city, phone
        case customerID = "customer_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case coordinates
        case isDefault = "default"
        case buildingNumber = "building_number"
        case floorNumber = "floor_number"
        case apartmentNumber = "apartment_number"
    }
}
