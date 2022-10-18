//
//  SideMenuViewModel.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import Foundation

class SideMenuViewModel: BaseViewModel {
    var updateTable: (()->())?
    
    private(set) var mainCategories = [MainCategory]()
    
    func getCategories() {
        startRequest(request: CategoriesApi.getCategories, mappingClass: BaseModel<[MainCategory]>.self) { [weak self] response in
            self?.mainCategories = response?.data ?? []
            self?.updateTable?()
        }
    }
}
