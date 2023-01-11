//
//  A.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 11/07/2021.
//

import Foundation

class SeeAllProductsViewModel: BaseViewModel {
    var categoryId = 0
    var products = [Product]()
    
    var completion:(()->())?
    var productCompletion: ((ProductDetailsVC?)->())?
    
    
//    func getProduct(for id:String) {
//
//        startRequest(request: ProductApi.showProduct(id: id),
//                     mappingClass: ProductResponse.self) { [weak self] response in
//            if let product = response?.data {
//                 let productVC = ProductDetailsVC(product: product)
//                print("&&&&&&\(productVC.viewModel.product?.productID)")
////                productVC.viewModel.product = product
////                productVC.viewModel.relatedProducts = response?.relatedProducts ?? []
//                self?.productCompletion?(productVC)
//            }else {
//                self?.productCompletion?(nil)
//            }
//        }
//    }
    
    func getProducts() {
        startRequest(request: CategoriesApi.getProducts(categoryId: categoryId),
                     mappingClass: PaginationModel<[Product]>.self) { [weak self] response in
            self?.products = response?.data?.data ?? []
            self?.completion?()
        }
    }
}
