//
//  MainCategory.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import Foundation


// MARK: - MainCategory
struct MainCategory: Codable {
    let id: Int
    let title: String
    let extra: String?
    let cType, relID, ins: Int
    let createdAt, updatedAt: String?
    let slug, nameAr, image: String
    let order, featured: Int
    let categoryID, iconImage: String
    let signature: Int
    let parent: String?
    let storeID: String
    let count: Int
    let name: String
    let children: [ChildCategory]?

    enum CodingKeys: String, CodingKey {
        case id, title, extra
        case cType = "c_type"
        case relID = "rel_id"
        case ins
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case slug
        case nameAr = "name_ar"
        case image, order, featured
        case categoryID = "category_id"
        case iconImage = "icon_image"
        case signature, parent
        case storeID = "store_id"
        case count, name, children
    }
}


struct ChildCategory: Codable {
    let id:Int?
    let title: String
    let name:String?
    let categories:[ChildCategory]?
    let nameAr, image: String
    let iconImage: String?
    
    private enum CodingKeys: String,CodingKey {
        case name, title
        case nameAr = "name_ar"
        case image, id, categories
        case iconImage = "icon_image"
    }
}

