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
        startRequest(request: CategoriesApi.getProducts(categoryId: id), mappingClass: PaginationModel<[Product]>.self) { response in
            completion(response?.data?.data ?? [])
        }
    }
    
    func getProduct(for barcode:String) {
        startRequest(request: ProductApi.barcode(barcode: barcode), mappingClass: ProductResponse.self) { [weak self] response in
            if let product = response?.data {
                 let productVC = ProductDetailsVC(product: product)
                self?.barcodeSearchCompletion?(productVC)
            }else {
                self?.barcodeSearchCompletion?(nil)
            }
        }
    }
}
