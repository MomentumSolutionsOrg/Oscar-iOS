//
//  SearchViewModel.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 05/07/2021.
//

import Foundation

class SearchViewModel: BaseViewModel {
    
    var completion:(()->())?
    var productCompletion: ((ProductDetailsVC?)->())?
    private(set) var products = [Product]()
    private(set) var filteredProducts = [Product]()
    private var searchQuery = ""
    var selectedSortName = ""
    var selectedSortPrice = ""
    var selectedCategories = [MainCategory]()
    var minPrice = ""
    var maxPrice = ""
    
    
    func search(for name:String) {
//        searchQuery = name
//        filterSort()
        startRequest(request: HomeApi.search(name: name), mappingClass: BaseModel<[Product]>.self) { [weak self] response in
            self?.searchQuery = name
            self?.products = response?.data ?? []
            self?.filteredProducts = response?.data ?? []
            self?.completion?()
        }
    }
    
    func getProduct(for id:String) {
        startRequest(request: ProductApi.showProduct(id: id), mappingClass: ProductResponse.self) { [weak self] response in
            if let product = response?.data {
                let productVC = ProductDetailsVC()
                productVC.viewModel.product = product
                productVC.viewModel.relatedProducts = response?.relatedProducts ?? []
                self?.productCompletion?(productVC)
            }else {
                self?.productCompletion?(nil)
            }
        }
    }
    
    func filterSort() {
//        let sort = SortParams(price: selectedSortPrice,name: selectedSortName)
//        let selectedFilters = selectedCategories
//            .map { $0.id.description }
//            .reduce("") { $0 + "," + $1 }.trimmingCharacters(in: .punctuationCharacters)
//        let filter = FilterParams(name: searchQuery,
//                                  filter: selectedFilters,
//                                  maxPrice: maxPrice, sortBy: sort)
//
//        startRequest(request: HomeApi.filter(filters: filter), mappingClass: BaseModel<[Product]>.self) { [weak self] response in
//            self?.products = response?.data ?? []
//            self?.completion?()
//        }
        filteredProducts = products
        if minPrice != "",
           maxPrice != "" {
            filteredProducts = filteredProducts.filter { (Double($0.regularPrice ?? "0") ?? 0.0) >= (Double(minPrice) ?? 0.0) && (Double($0.regularPrice ?? "0") ?? 0.0) <= (Double(maxPrice) ?? 1.0) }
        }
        
        if selectedSortName != "" {
            switch selectedSortName {
            case "a_to_z":
                filteredProducts = filteredProducts.sorted { ($0.name ?? "") < ($1.name ?? "") }
            case "z_to_a":
                filteredProducts = filteredProducts.sorted { ($0.name ?? "") > ($1.name ?? "") }
            default:
                break
            }
        }
        
        if selectedSortPrice != "" {
            switch selectedSortPrice {
            case "low_to_high":
                filteredProducts = filteredProducts.sorted { (Double($0.regularPrice ?? "0") ?? 0.0)  < (Double($1.regularPrice ?? "0") ?? 0.0) }
            case "high_to_low":
                filteredProducts = filteredProducts.sorted { (Double($0.regularPrice ?? "0") ?? 0.0)  > (Double($1.regularPrice ?? "0") ?? 0.0) }
            default:
                break
            }
        }
        if !selectedCategories.isEmpty {
            let categoriesIDs = selectedCategories.map { $0.id }
            filteredProducts = filteredProducts.filter { categoriesIDs.contains($0.categoryID ?? 0) }
        }
        completion?()
    }
    
    func resetFilters() {
        selectedSortName = ""
        selectedSortPrice = ""
        selectedCategories = [MainCategory]()
        minPrice = "1"
        maxPrice = "4000"
        filteredProducts = products
        completion?()
    }
    
}
