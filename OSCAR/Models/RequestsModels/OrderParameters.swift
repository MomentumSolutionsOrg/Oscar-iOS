//
//  OrderParameters.swift
//  OSCAR
//
//  Created by Mostafa Samir on 16/08/2021.
//

import Foundation

struct OrderParameters: RequestParameters {
    let token: String
    let setPaid: Bool
    let user: OrderUser
    let address: OrderAddress
    let coordinates: String
    let phone: String
    let paymentMethod: String
    let lineItems: [LineItem]
    let currency: String
    let storeId: String
    let cost: String
    let flag: String
    let deliveryDate: String?
    let notes: String
    
    init(address:Address, paymentMethod: String, cartItems: [Product], deliveryFee: DeliveryFees, deliveryDate: String?) {
        self.token = CurrentUser.shared.token ?? ""
        self.setPaid = false
        self.user = OrderUser(address: address)
        self.address = OrderAddress(address: address)
        if let coordinates = address.coordinates,
           !coordinates.isEmpty {
            self.coordinates = coordinates
        }else {
            self.coordinates = Utils.defaultCoordinate()
        }
        
        self.phone = address.phone ?? ""
        self.paymentMethod = paymentMethod
        self.lineItems = cartItems.map { LineItem(product: $0) }
        self.currency = "EGP".localized
        self.storeId = CurrentUser.shared.store
        self.deliveryDate = deliveryDate
        self.notes = ""
        self.flag = deliveryFee.flag ?? ""
        self.cost = deliveryFee.cost ?? ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case token, user, address, phone
        case currency, cost, flag, notes
        case setPaid = "set_paid"
        case coordinates = "coordinates_new"
        case paymentMethod = "payment_method"
        case lineItems = "line_items"
        case deliveryDate = "delivery_date"
        case storeId = "store_id"
        
        
    }
}


struct OrderUser: RequestParameters {
    let buildingNumber: String
    let floorNumber: String
    let apartmentNumber: String
    init(address: Address) {
        self.buildingNumber = address.buildingNumber ?? ""
        self.floorNumber = address.floorNumber ?? ""
        self.apartmentNumber = address.apartmentNumber ?? ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case buildingNumber = "building_no"
        case floorNumber = "floor_no"
        case apartmentNumber = "apartment_no"
    }
}


struct OrderAddress: RequestParameters {
    let address: String
    let city: String
    let area: String
    
    init(address: Address) {
        self.address = address.address ?? ""
        self.city = address.city ?? ""
        self.area = address.area ?? ""
    }
}

struct LineItem: RequestParameters {
    let productId: String
    let quantity: Int
    let price: Double
    let weight: String
    let priceUnit: String
    
    init(product: Product) {
        self.productId = product.id ?? ""
        self.quantity = Int(product.quantity ?? 1)
        self.price = product.total ?? 1
        self.weight = product.weight ?? "1"
        self.priceUnit = product.priceUnit ?? "quantity"
    }
    
    private enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case priceUnit = "price_unit"
        case quantity, price, weight
    }
}
