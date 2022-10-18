//
//  FilterSortParams.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 08/07/2021.
//

import Foundation

struct FilterParameters: RequestParameters {
    /*
     {“name”:null,“page”:“1”,“filter”:“5637164849”,“lang”:“en”,“store_id”:“01”,“sortBy”:“{\“price\“:\“low_to_high\“,\“name\“:\“a_to_z\“}”}
     */
    let name:String   // search name
    let filter:String //categories ids seperated by commas
    var lang:String = (LanguageManager.shared.getCurrentLanguage() ?? "en")
    var storeID:String = CurrentUser.shared.store
    let maxPrice:String
    let sortBy:SortParameters
    
    private enum CodingKeys: String, CodingKey {
        case name,filter,lang,sortBy
        case storeID = "store_id"
        case maxPrice = "max_price"
    }
}

struct SortParameters: RequestParameters {
    let price:String
    let name:String
    
    init(price:String,name:String) {
        self.price = price
        self.name = name
    }
}
