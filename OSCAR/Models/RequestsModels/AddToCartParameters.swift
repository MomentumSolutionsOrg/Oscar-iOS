//
//  AddToCartParameters.swift
//  OSCAR
//
//  Created by Mostafa Samir on 03/08/2021.
//

import Foundation
/*
 product_id":"059944kg","quantity":-1,"weight":250,"store_id":"01"
 */
struct AddToCartParameters: RequestParameters {
    let productId: String
    let quantity: Int
    let weight: String
    var storeId: String
    
    init(productId: String, quantity:Int, weight:String) {
        self.productId = productId
        self.quantity = quantity
        self.weight = weight
        self.storeId = CurrentUser.shared.store
    }
    
    private enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case quantity
        case weight
        case storeId = "store_id"
    }
}
