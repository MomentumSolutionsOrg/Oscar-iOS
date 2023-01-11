//
//  ProductDetailsViewModel.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 05/07/2021.
//

import Foundation

class ProductDetailsViewModel: BaseViewModel {
    var product:Product? {
        didSet {
            //😭
//            if product?.priceUnit?.lowercased().contains("quantity") ?? true {
//                hasSizes = false
//            }else {
//                hasSizes = true
//            }
            isWishListed = product?.liked ?? false
            size = "1000"
            quantity = 1
        }
    }
    var relatedProducts = [Product]()
    private(set) var hasSizes = false
    var quantity = 1
    var isWishListed = false
    var size = "1000"
    
    var addToCartCompletion: ((String) -> Void)?
    var showRelatedProductCompletion: (() -> ())?
    var showProductCompletion: (() -> ())?
    func addToCart() {
        let parameters = AddToCartParameters(productId: product?.productID ?? "",
                                             quantity: quantity,
                                             weight: hasSizes ? size : "")
        startRequest(request: CheckoutProcessApi.addToCart(parameters: parameters), mappingClass: MessageModel.self) { [weak self] response in
            Utils.checkCart()
            self?.addToCartCompletion?(response?.message ?? "added")
        }
    }
    
    func updateWishList() {
        if isWishListed {
            addToWishList()
        }else {
            removeFromWishList()
        }
    }
    
    func fetchProduct(for id: String) {
        print("fetchProduct \(id)")
        startRequest(request: ProductApi.showProduct(id: id),
                     mappingClass: ProductResponse.self) { [weak self] response in
            self?.product = response?.data
            self?.relatedProducts = response?.relatedProducts ?? []
            self?.showRelatedProductCompletion?()
        }
    }
    private func addToWishList() {
        startRequest(request: WishListApi.addToWishList(productId: product?.productID ?? ""), mappingClass: MessageModel.self) { response in
            print(response?.message ?? "no message")
        }
    }
    
    private func removeFromWishList() {
        startRequest(request: WishListApi.removeFromWishList(productIds: [product?.productID ?? ""]), mappingClass: MessageModel.self) { response in
            print(response?.message ?? "no message")
        }
    }
    func getProductDetails(){
        if product != nil {
            print("getProductDetails\(product?.productID)")
            startRequest(request: ProductApi.showProduct(id: product?.productID ?? ""), mappingClass: ProductResponse.self) { [weak self] response in
                self?.product = response?.data
                self?.relatedProducts = response?.relatedProducts ?? []
                self?.showProductCompletion?()
            }
        }
    }
}
