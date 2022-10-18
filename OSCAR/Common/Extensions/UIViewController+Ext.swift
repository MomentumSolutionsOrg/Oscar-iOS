//
//  UIViewController+Ext.swift
//  Expert
//
//  Created by Mac Store Egypt on 30/05/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func push(_ viewController: UIViewController) {
        navigationController?.fadeTo(viewController)
    }
    func pushWithTabBar(vc: UIViewController, isTabBarHidden: Bool = false) {
        if isTabBarHidden {
            hideTabBar()
        }
        navigationController?.fadeTo(vc)
    }
    func pop() {
        navigationController?.fadeOut()
    }
    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
    }
    func popToRoot() {
        navigationController?.popRoot()
        dismiss()
    }
    
    func setTabbar() {
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
    }
    
//    func setComapnyFlow() {
//        let nc = UINavigationController(rootViewController: CompanyMainVC())
//        nc.navigationBar.isHidden = true
//        UIApplication.shared.keyWindow?.rootViewController = nc
//    }
    func present(_ viewController:UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func setRootViewController(vc: UIViewController) {
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    
    func showSettingsAlert(title:String?, message:String?) {

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)

            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                }
            }

            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            present(alertController)
        }
    
    static var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController  {
            while let presentedViewController = topController
                    .presentedViewController  {
                topController = presentedViewController
                
            }
            return topController
            
        }
        return nil
    }
}
