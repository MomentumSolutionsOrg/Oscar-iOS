//
//  OfferCategoryViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 10/08/2021.
//

import Foundation

class OfferCategoryViewModel: BaseViewModel {
    
    private var offer:String
  
    init(offer: String) {
        self.offer = offer
    }
    
    private(set) var offerProducts = [Product]()
    var shouldPaginate = false
    var productCompletion: ((ProductDetailsVC?)->())?
    var successCompletion: (() -> Void)?
    
    func fetchOfferProducts() {
        startRequest(request: OffersApi.getOfferProducts(name: offer), mappingClass: BaseModel<[Product]>.self) { [weak self] response in
            self?.offerProducts = response?.data ?? []
            self?.successCompletion?()
        }
    }
    
//    func getProduct(for id:String) {
//        startRequest(request: ProductApi.showProduct(id: id), mappingClass: ProductResponse.self) { [weak self] response in
//            if let product = response?.data {
//                 let productVC = ProductDetailsVC(product: product)
//                //😭
//                self?.productCompletion?(productVC)
//            }else {
//                self?.productCompletion?(nil)
//            }
//        }
//    }
}
