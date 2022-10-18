//
//  MainTabBarController.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 22/06/2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    private let cartButton = UIButton()
    private let cartBottomView = UIView()
    private let cartDetailsView = UIView()
    private let totalCartLabel = UILabel()
    private let cartTotalPriceLabel = UILabel()
    private let cartItemsCountLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .clear
        delegate = self
        setValue(CustomizedTabBar(), forKey: "tabBar")
        viewControllers = [createHomeVC(), createCategoryVC(), createCartVC(), createOffersVC(), createWishlistViewController()]
        setupCartButton()
        setupCartBottomView()
        setupCartDetailsView()
        setupCartCountLabel()
        addObserverToCartChanges()
        Utils.checkCart()
    }
    
    func createHomeVC() -> UINavigationController{
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home"), tag: 0)
        homeVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "Group 763")
        let navigationController =  UINavigationController(rootViewController: homeVC)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }


    func createCategoryVC() -> UINavigationController {
        let categoryVC = CategoriesVC()
        categoryVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "menu"), tag: 1)
        categoryVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "Group 766")
        let navigationController =  UINavigationController(rootViewController: categoryVC)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }

    func createCartVC() -> UINavigationController {
        var cart:UIViewController = TabBarLoginViewController()
        if let token = CurrentUser.shared.token, token != "" {
            cart = CartViewController()
        }
        cart.tabBarItem = UITabBarItem(title: "", image:nil, tag: 2)
        if let cart = cart as? TabBarLoginViewController {
            cart.topTitle = "shopping_cart".localized
        }
        let navigationController =  UINavigationController(rootViewController: cart)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func createOffersVC() -> UINavigationController {
        var offersVC:UIViewController = TabBarLoginViewController()
        if let token = CurrentUser.shared.token, token != "" {
            offersVC = OffersViewController()
        }
        offersVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "price-tag"), tag: 3)
        offersVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "Group 765")
        let navigationController =  UINavigationController(rootViewController: offersVC)
        if let offersVC = offersVC as? TabBarLoginViewController {
            offersVC.topTitle = "deals_offers".localized
        }
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    func createWishlistViewController() -> UINavigationController {
        var wishlistViewController:UIViewController = TabBarLoginViewController()
        if let token = CurrentUser.shared.token, token != "" {
            wishlistViewController = WishListViewController()
        }
        wishlistViewController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "passion"), tag: 4)
        wishlistViewController.tabBarItem.selectedImage = #imageLiteral(resourceName: "Group 764")
        if let wishlistViewController = wishlistViewController as? TabBarLoginViewController {
            wishlistViewController.topTitle = "my_favorites".localized
        }
        let navigationController =  UINavigationController(rootViewController: wishlistViewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func setupCartButton() {
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.setImage(#imageLiteral(resourceName: "shopping-cart"), for: .normal)
        cartButton.backgroundColor = .white
        cartButton.tintColor = UIColor(hexString: "#4b4b4b")
        self.tabBar.addSubview(cartButton)
        NSLayoutConstraint.activate([
            cartButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            cartButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 30),
            cartButton.heightAnchor.constraint(equalToConstant: 60),
            cartButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        cartButton.layer.cornerRadius = 30
        cartButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        cartButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        cartButton.layer.shadowRadius = 2
        cartButton.layer.shadowOpacity = 0.09
        //shadowView.layer.cornerRadius = 20.0
        cartButton.layer.masksToBounds = false
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }
    
    func setupCartBottomView() {
        cartBottomView.translatesAutoresizingMaskIntoConstraints = false
        cartBottomView.isHidden = true
        cartBottomView.backgroundColor = UIColor.blueColor
        self.tabBar.addSubview(cartBottomView)
        self.tabBar.bringSubviewToFront(cartBottomView)
        NSLayoutConstraint.activate([
            cartBottomView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            cartBottomView.topAnchor.constraint(equalTo: tabBar.topAnchor  ,constant: 45),
            cartBottomView.heightAnchor.constraint(equalToConstant: 2),
            cartBottomView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @objc private func cartButtonTapped() {
        self.selectedIndex = 2
        self.tabBar(tabBar, didSelect: (self.tabBar.items!)[2])
    }
    
}

@objc extension MainTabBarController: UITabBarControllerDelegate  {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items!)[2] {
            cartBottomView.isHidden = false
            cartButton.tintColor = UIColor.blueColor
        }else {
            cartBottomView.isHidden = true
            cartButton.tintColor = UIColor(hexString: "#4b4b4b")
        }
    }
}
//MARK: - Cart Details View Methods And Observers
private extension MainTabBarController {
    func setupCartDetailsView() {
        cartTotalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        cartTotalPriceLabel.text = "66 \("EGP".localized)"
        cartTotalPriceLabel.font = .boldSystemFont(ofSize: 12)
        cartTotalPriceLabel.textColor = .white
        
        totalCartLabel.translatesAutoresizingMaskIntoConstraints = false
        totalCartLabel.text = "total_cart".localized
        totalCartLabel.font = .boldSystemFont(ofSize: 12)
        totalCartLabel.textColor = .white
        
        cartDetailsView.addSubview(cartTotalPriceLabel)
        cartDetailsView.addSubview(totalCartLabel)
        
        NSLayoutConstraint.activate([
            totalCartLabel.leadingAnchor.constraint(equalTo: cartDetailsView.leadingAnchor, constant: 8),
            totalCartLabel.topAnchor.constraint(equalTo: cartDetailsView.topAnchor, constant: 4),
            totalCartLabel.bottomAnchor.constraint(equalTo: cartDetailsView.bottomAnchor, constant: -4),
            
            cartTotalPriceLabel.trailingAnchor.constraint(equalTo: cartDetailsView.trailingAnchor, constant: -8),
            cartTotalPriceLabel.topAnchor.constraint(equalTo: cartDetailsView.topAnchor, constant: 4),
            cartTotalPriceLabel.bottomAnchor.constraint(equalTo: cartDetailsView.bottomAnchor, constant: -4)
        ]
        )
        cartDetailsView.isHidden = true
        cartDetailsView.translatesAutoresizingMaskIntoConstraints = false
        cartDetailsView.backgroundColor = UIColor.blueColor
        cartDetailsView.layoutIfNeeded()
        cartDetailsView.layer.cornerRadius = cartDetailsView.frame.height / 2
        cartDetailsView.clipsToBounds = true
        tabBar.addSubview(cartDetailsView)
        tabBar.sendSubviewToBack(cartDetailsView)
        NSLayoutConstraint.activate([
            cartDetailsView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 10),
            cartDetailsView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: -10),
            cartDetailsView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0)
        ]
        )
    }
    
    func setupCartCountLabel() {
        cartItemsCountLabel.isHidden = true
        cartItemsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        cartItemsCountLabel.text = "4"
        cartItemsCountLabel.textColor = .white
        cartItemsCountLabel.backgroundColor = UIColor.redColor
        cartItemsCountLabel.font = .systemFont(ofSize: 8)
        cartItemsCountLabel.textAlignment = .center
        tabBar.addSubview(cartItemsCountLabel)
        NSLayoutConstraint.activate([
            cartItemsCountLabel.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor,constant: 10),
            cartItemsCountLabel.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            cartItemsCountLabel.heightAnchor.constraint(equalToConstant: 12),
            cartItemsCountLabel.widthAnchor.constraint(equalToConstant: 12)
        ])
        cartItemsCountLabel.layoutIfNeeded()
        cartItemsCountLabel.layer.cornerRadius = cartItemsCountLabel.frame.height / 2
        cartItemsCountLabel.clipsToBounds = true
    }
    
    func addObserverToCartChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartNotificationReceived(_:)), name: Notification.Name(Constants.NotificationNames.cartUpdated.rawValue), object: nil)
    }
    
    @objc private func cartNotificationReceived(_ notification: Notification) {
        if let cartCount = notification.userInfo?["cart_count"] as? Int,
           let cartCost = notification.userInfo?["cart_total"] as? Double,
           cartCount > 0 {
            cartDetailsView.isHidden = false
            cartItemsCountLabel.isHidden = false
            let roundedTotal = round(cartCost * 100)/100
            cartTotalPriceLabel.text = roundedTotal.description + " " + "EGP".localized
            cartItemsCountLabel.text = cartCount.description
        }else {
            cartDetailsView.isHidden = true
            cartItemsCountLabel.isHidden = true
        }
    }
}
