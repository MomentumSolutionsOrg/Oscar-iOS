//
//  OffersViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import Foundation

class OffersViewModel: BaseViewModel {
    
    var offers = [Offer]()
    var successCompletion: (() -> Void)?
    var productCompletion: ((ProductDetailsVC?)->())?
    var addToCartCompletion: ((String) -> Void)?
    
    func fetchOffers() {
        startRequest(request: OffersApi.getOffers, mappingClass: BaseModel<[Offer]>.self) { [weak self] response in
            self?.offers = response?.data ?? []
            self?.successCompletion?()
        }
    }
    
//    func getProduct(for id:String) {
//        startRequest(request: ProductApi.showProduct(id: id), mappingClass: ProductResponse.self) { [weak self] response in
//            if let product = response?.data {
//                 let productVC = ProductDetailsVC(product: product)
//                //😭
////                productVC.viewModel.product = product
////                productVC.viewModel.relatedProducts = response?.relatedProducts ?? []
//                self?.productCompletion?(productVC)
//            }else {
//                self?.productCompletion?(nil)
//            }
//        }
//    }
    
    func addToWishList(id: String) {
        startRequest(request: WishListApi.addToWishList(productId: id), mappingClass: MessageModel.self) { [weak self] response in
            self?.fetchOffers()
            print(response?.message ?? "no message")
        }
    }
    
    func removeFromWishList(id: String) {
        startRequest(request: WishListApi.removeFromWishList(productIds: [id]), mappingClass: MessageModel.self) { [weak self] response in
            self?.fetchOffers()
            print(response?.message ?? "no message")
        }
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
