//
//  OrdersApi.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import Alamofire

enum OrdersPaths {
    static let orders = "orders/get"
    static let lastOrder = "orders_last/get?"
    static let createOrder = "orders"
}

enum OrdersApi: Requestable {
    
    case getOrders
    case getLastOrder
    case createOrder(orderParameters: OrderParameters)
    
    var path: String {
        switch self {
        case .getOrders:
            return OrdersPaths.orders
        case .getLastOrder:
            return OrdersPaths.lastOrder + (LanguageManager.shared.getCurrentLanguage() ?? "en")
        case .createOrder:
            return OrdersPaths.createOrder
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getOrders:
            return .get
        case .getLastOrder:
            return .get
        case .createOrder:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getOrders, .getLastOrder:
           return nil
        case .createOrder(let orderParameters):
            return orderParameters.getParamsAsJson()
        }
    }
}
