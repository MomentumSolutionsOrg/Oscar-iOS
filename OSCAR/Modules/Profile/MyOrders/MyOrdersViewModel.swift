//
//  MyOrdersViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import Foundation

class MyOrdersViewModel: BaseViewModel {
    
    private(set) var orders = [Order]()
    var selectedOrder: Order?
    var selectedOrderStatus: Constants.OrderStatus = .pending
    
    var fetchOrdersCompletion: (() -> Void)?
    var showSuccessMessage: ((String) -> ())?
    
    func fetchOrders() {
        startRequest(request: OrdersApi.getOrders, mappingClass: BaseModel<[Order]>.self) { [weak self] response in
            self?.orders = response?.data ?? []
            self?.fetchOrdersCompletion?()
        }
    }
    
    func subtotal() -> Double {
        guard let products = selectedOrder?.products else { return 0.0 }
        return 0.0
        //😭
//        products
//            .compactMap { $0.total }
//            .reduce(0.0) { $0 + $1 }
    }
    
    func total() -> Double  {
        guard let selectedOrder = selectedOrder else { return 0.0 }
        let delivery = Double(selectedOrder.deliveryFees ?? "20") ?? 20.0
        return delivery + subtotal()
    }
    
    func reorderSelectedOrder() {
        if let itemsIds = selectedOrder?.products?.compactMap({ $0.productID}) {
            startRequest(request: WishListApi.addSelectedToCart(itemsIds), mappingClass: MessageModel.self) {[weak self] response in
                self?.showSuccessMessage?("items_added_to_cart".localized)
            }
        }
    }
}
