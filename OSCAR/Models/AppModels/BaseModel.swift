//
//  ErrorModel.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 15/06/2021.
//

import Foundation

struct ErrorModel: Codable {
    var error: String
}

struct MessageModel: Codable {
    var message: String
}

struct BaseModel<T: Codable>: Codable {
    var message: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case message
        case data
    }
}

struct PaginationModel<T: Codable>: Codable {
    var data: PaginationData<T>?
}

struct PaginationData<T: Codable>: Codable {
    let totalPages:Int?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "last_page"
        case data
    }
}
