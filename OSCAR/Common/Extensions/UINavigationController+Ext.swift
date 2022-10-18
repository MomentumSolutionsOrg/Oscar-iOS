//
//  UINavigationController+Ext.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 31/05/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

extension UINavigationController {
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func fadeOut() {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
    }
    
    func popRoot() {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        popToRootViewController(animated: false)
    }
}
