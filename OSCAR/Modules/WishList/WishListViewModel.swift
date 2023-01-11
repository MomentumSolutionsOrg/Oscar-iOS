//
//  WishListViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/08/2021.
//

import Foundation

protocol WishListDelegate: AnyObject {
    func remove(for id: String)
    func addToCart(for id: String)
}

class WishListViewModel: BaseViewModel {
    private(set) var products = [Product]() {
        didSet {
            self.successCompletion?()
        }
    }
    var selectedProducts = [Product]()
    
    var successCompletion: (() -> Void)?
    var addToCartCompletion: ((String) -> Void)?
    var showSuccessMessage: ((String) ->())?
    
    func fetchWishList() {
        startRequest(request: WishListApi.getWishList, mappingClass: BaseModel<[Product]>.self) { [weak self] response in
            self?.products = response?.data ?? []
        }
    }
    
    func removeFromWishList(with ids: [String], showSuccessAlert: Bool = false) {
        startRequest(request: WishListApi.removeFromWishList(productIds: ids), mappingClass: MessageModel.self) { [weak self] response in
            self?.removeItemsFromLocalWishlist(ids: ids)
        }
    }
    
    func removeItemsFromLocalWishlist(ids: [String]) {
        for id in ids {
            selectedProducts.removeAll { $0.productID == id }
            products.removeAll { $0.productID == id }
        }
    }
    
    func checkSelection(at indexPath: IndexPath) -> Bool {
        let productId = products[indexPath.row].productID
        return selectedProducts.contains { $0.productID == productId }
    }
    
    func toggleSelection(at indexPath: IndexPath) {
        let productId = products[indexPath.row].productID
        if selectedProducts.contains(where: { $0.productID == productId }) {
            selectedProducts.removeAll { $0.productID == productId }
        } else {
            selectedProducts.append(products[indexPath.row])
        }
    }
    
    func addSelectedItemsToCart() {
        let itemsIds = selectedProducts.compactMap {$0.productID}
        startRequest(request: WishListApi.addSelectedToCart(itemsIds), mappingClass: MessageModel.self) {[weak self] response in
            self?.showSuccessMessage?("wishlist_add_message".localized)
            Utils.checkCart()
        }
    }
}


extension WishListViewModel: WishListDelegate {
    func remove(for id: String) {
        removeFromWishList(with: [id])
    }
    
    func addToCart(for id: String) {
        let parameters = AddToCartParameters(productId:id,
                                             quantity: 1,
                                             weight: "")
        startRequest(request: CheckoutProcessApi.addToCart(parameters: parameters), mappingClass: MessageModel.self) { [weak self] response in
            Utils.checkCart()
            self?.addToCartCompletion?(response?.message ?? "added")
        }
    }
    
}
