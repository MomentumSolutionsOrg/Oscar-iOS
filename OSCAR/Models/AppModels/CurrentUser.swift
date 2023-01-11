//
//  CurrentUser.swift
//  OSCAR
//
//  Created by Asmaa Tarek on 27/06/2021.
//

import Foundation

class CurrentUser {
    static let shared = CurrentUser()
    private init() {}
    var token: String?
    var user: User?
    var store:String = "02" {
        didSet {
            UserDefaultsManager.shared.saveInUserDefault(key: .storeId, data: store)
        }
    }
    
    var defaultPaymentType = 0 {
        didSet {
            UserDefaultsManager.shared.saveInUserDefault(key: .paymentType, data: defaultPaymentType)
        }
    }
    
    // this is used to generate ids for realm objects
    var checkListCount = 0 {
        didSet {
            UserDefaultsManager.shared.saveInUserDefault(key: .checkListCount, data: checkListCount)
        }
    }
    
    
    var cartCount = 0
    var cartTotal = 0.0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(Constants.NotificationNames.cartUpdated.rawValue), object: nil, userInfo: ["cart_count": cartCount,"cart_total":cartTotal])
        }
    }
}
