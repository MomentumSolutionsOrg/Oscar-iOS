//
//  AddressParams.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import Foundation

struct AddressParameters: RequestParameters {
    let name: String
    let address:String
    let city: String
    let phone: String
    let isDefault: String
    let area: String
    var coordinates: String
    let apartmentNumber: String
    let buildingNumber: String
    let floorNumber: String
    let landline: String?
    private enum CodingKeys: String, CodingKey {
        case name
        case address
        case city
        case phone
        case isDefault = "default"
        case area
        case coordinates
        case apartmentNumber = "apartment_no"
        case buildingNumber = "floor_no"
        case floorNumber = "building_no"
        case landline = "land_line"
    }
}
