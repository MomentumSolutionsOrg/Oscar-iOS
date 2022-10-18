//
//  AboutUsViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 07/09/2021.
//

import Foundation


class AboutUsViewModel: BaseViewModel {
    var reloadHtml: ((String) -> Void)?
    
    func fetchData() {
        startRequest(request: StaticPagesApi.aboutUs, mappingClass: BaseModel<AboutUs>.self) { [weak self] response in
            if let html = response?.data?.content {
                self?.reloadHtml?(html)
            }
        }
    }
}
