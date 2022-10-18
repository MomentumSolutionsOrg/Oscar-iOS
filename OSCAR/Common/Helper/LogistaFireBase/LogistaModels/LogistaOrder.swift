//
//  LogistaOrder.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import Foundation

struct LogistaOrder: Codable {
    let driverId: String?
    let pickup: LogistaAddress?
    let delivery: LogistaAddress?
    let status: Int?
    
}

struct LogistaAddress: Codable {
    let address: LogistaAddressCoordinates?
}

struct LogistaAddressCoordinates: Codable {
    let lat: String?
    let lng: String?
}
