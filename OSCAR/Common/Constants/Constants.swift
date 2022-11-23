//
//  Constants.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 10/06/2021.
//

import Foundation

enum Constants {
    static let hotline = "16991"
    static let closingDeliveryTime = "10:00 PM"
    enum ConnectionType {
        case wifi
        case ethernet
        case cellular
        case unknown
    }
    
    enum NotificationTopic: String {
        case oscarNotifyiOS = "oscarNotifyiOS"
        case oscarNotifyiOSTest = "oscarNotifyiOSTest"
    }
    
    enum UserDefaultKeys: String, CaseIterable {
        case token = "token"
        case userData = "user_data"
        case storeId = "store_id"
        case currentStoreCoordinates = "current_Store_Coordinates"
        case paymentType = "payment_type"
        case checkListCount = "checklist_count"
        case notification = "notification"
        case fCMToken = "fCM_token"
    }
    
    enum Format {
        static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let fullDate = "dd/MM/yyyy hh:mm a"
        static let timeFormat = "hh:mm a"
        static let dayFormat = "dd/MM/yyyy"
    }
    
    enum ProfileItems: String {
        case address = "address"
        case barcode = "barcode"
        case orders = "orders"
        case voucher = "vouchers"
    }
    
    enum FilterItems: String {
        case category = "category"
        case priceRange = "price_range"
    }
    
    
    //Mostafa
    
    enum ShowType {
        case grid
        case list
    }
    
    enum DeepLinkingPaths: String {
        case showProduct = "show_product"
        case allProducts = "all_products"
        case aboutus = "aboutus"
        case contact = "contact"
        case department = "department"
        
    }
    
    enum NotificationNames: String {
        case cartUpdated = "cart_updated"
    }
    
    enum OrderStatus: String {
        case pending
        case assigned
        case onTheWay
        case preparing
        case completed
        case checkingStatus
    }
    
    enum PaymentMethodTypes: Int {
        case cashOnDelivery
        case cardUponDelivery
        case visa
    }
    
    enum DeliveryTypes: String {
        case sameDay = "Same Day Shopping (within the day)"
        case schedule = "Scheduled"
    }
}

