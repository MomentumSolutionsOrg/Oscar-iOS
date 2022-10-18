//
//  DeepLinkingNavigator.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/09/2021.
//

import UIKit

class DeepLinkingNavigator {
    static let shared = DeepLinkingNavigator()
    private init() {}
    
    func parse(link: String) {
        guard let url = URL(string: link) else { return }
        let components = url.pathComponents

        if components.contains(Constants.DeepLinkingPaths.allProducts.rawValue) {

            if let categoryId = Int(components.last ?? "0") {
                fetchCategoryProducts(for: categoryId)
            }
        }else if components.contains(Constants.DeepLinkingPaths.showProduct.rawValue) {
            if let indexOfShowProducts = components.firstIndex(of: Constants.DeepLinkingPaths.showProduct.rawValue) {
                
                let indexOFID = components.index(after: indexOfShowProducts)
                let productId = components[indexOFID]
            
                    fetchProduct(for: productId)
            }
         
        } else if components.contains(Constants.DeepLinkingPaths.aboutus.rawValue) {
            
            self.push(viewController: AboutUsViewController())
            
        } else if components.contains(Constants.DeepLinkingPaths.contact.rawValue) {
            
            self.push(viewController: ContactUsViewController())
            
        } else if components.contains(Constants.DeepLinkingPaths.department.rawValue) {
            
            if let tabBar = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController {
                tabBar.selectedIndex = 1
            }
        }
    }

    private func fetchProduct(for id:String) {
        Api().fireRequestWithSingleResponse(urlConvertible: ProductApi.showProduct(id: id), mappingClass: ProductResponse.self).get { [weak self] response in
            if let product = response.data {
                let productVC = ProductDetailsVC()
                productVC.viewModel.product = product
                productVC.viewModel.relatedProducts = response.relatedProducts ?? []
                self?.push(viewController: productVC)
            }
        }.catch { error in
            print(error)
        }
    }
    
    func fetchCategoryProducts(for id:Int) {
        Api().fireRequestWithSingleResponse(urlConvertible: CategoriesApi.getProducts(categoryId: id), mappingClass: BaseModel<[Product]>.self).get {[weak self] response in
            if let products = response.data,
               !products.isEmpty {
                let vc = SeeAllProductsVC()
                vc.viewModel.products = products
                self?.push(viewController: vc)
            }
        }.catch { error in
            print(error)
        }
    }
    
    func push(viewController: UIViewController) {
        if let tabBar = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController,
           let currentController = tabBar.viewControllers?[tabBar.selectedIndex] as? UINavigationController {
            currentController.pushViewController(viewController, animated: true)
        }
    }
}
