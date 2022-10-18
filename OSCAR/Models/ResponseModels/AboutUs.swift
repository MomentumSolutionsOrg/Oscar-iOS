//
//  AboutUs.swift
//  OSCAR
//
//  Created by Mostafa Samir on 07/09/2021.
//

import Foundation

struct AboutUs: Codable {
    let id: Int?
    let pageName, content: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pageName = "page_name"
        case content
    }
}
