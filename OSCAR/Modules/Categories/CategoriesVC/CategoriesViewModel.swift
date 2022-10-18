//
//  CategoriesViewModel.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import Foundation

class CategoriesViewmodel: BaseViewModel {
    var updateTable: (()->())?
    var barcodeSearchCompletion: ((ProductDetailsVC?)->())?
    private var storeId = ""
    private(set) var mainCategories = [MainCategory]()

    func getCategories() {
        if storeId != CurrentUser.shared.store {
            storeId = CurrentUser.shared.store
            startRequest(request: CategoriesApi.getCategories, mappingClass: BaseModel<[MainCategory]>.self) { [weak self] response in
                self?.mainCategories = response?.data ?? []
                self?.updateTable?()
            }
        }
    }
    
    func getProducts(for id:Int,completion:@escaping ([Product])->()) {
        startRequest(request: CategoriesApi.getProducts(categoryId: id), mappingClass: BaseModel<[Product]>.self) { response in
            completion(response?.data ?? [])
        }
    }
    
    func getProduct(for barcode:String) {
        startRequest(request: ProductApi.barcode(barcode: barcode), mappingClass: BarcodeResponse.self) { [weak self] response in
            if let product = response?.data?.first {
                let productVC = ProductDetailsVC()
                productVC.viewModel.product = product
                productVC.viewModel.relatedProducts = response?.relatedProducts ?? []
                self?.barcodeSearchCompletion?(productVC)
            }else {
                self?.barcodeSearchCompletion?(nil)
            }
        }
    }
}
