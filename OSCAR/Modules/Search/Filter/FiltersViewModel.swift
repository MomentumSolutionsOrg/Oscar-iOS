//
//  FiltersViewmodel.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import Foundation

class FiltersViewModel: BaseViewModel {
    private(set) var filterItems:[Constants.FilterItems] = [.category,.priceRange]
    private(set) var mainCategories = [MainCategory]()
    var updateTable: (()->())?
    
    var selectedCategories = [MainCategory]()
    var minPrice = ""
    var maxPrice = ""
    
    func getCategories() {
        startRequest(request: CategoriesApi.getCategories, mappingClass: BaseModel<[MainCategory]>.self) { [weak self] response in
            self?.mainCategories = response?.data ?? []
            self?.updateTable?()
        }
    }
    
}
