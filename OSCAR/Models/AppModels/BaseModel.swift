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
    let message: String?
    var data: PaginationData<T>?
}


// MARK: - PaginationData
struct PaginationData<T: Codable>: Codable {
    let currentPage: Int
    let data: T?
    let firstPageURL: String
    let from, lastPage: Int
    let lastPageURL: String
    let nextPageURL, path: String
    let perPage: Int
    let prevPageURL: String?
    let to, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}
