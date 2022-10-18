//
//  MainCategory.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import Foundation

struct MainCategory: Codable {
    let id:Int?
    let name:String?
    let children:[ChildCategory]?
    let image:ImageModel?
    let count:Int?
    let iconImage: String?
    private enum CodingKeys: String,CodingKey {
        case name = "category_name"
        case image, id, count
        case children = "children_categories"
        case iconImage = "icon_image"
    }
}

struct ChildCategory: Codable {
    let id:Int?
    let name:String?
    let categories:[ChildCategory]?
    let image:ImageModel?
    let iconImage: String?
    
    private enum CodingKeys: String,CodingKey {
        case name = "category_name"
        case image, id, categories
        case iconImage = "icon_image"
    }
}

struct ImageModel: Codable {
    let src:String
}
