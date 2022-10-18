//
//  Slider.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import Foundation

struct Slider: Codable {
    let id: Int?
    let bannerName: String?
    let image: String?
    let order: Int?
    let link: String?
    let appLink: String?
    let createdAt: String?
    let updatedAt, type: String?
    let width, height: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case bannerName = "banner_name"
        case image, order, link
        case appLink = "app_link"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case type
        case width, height
    }
}

