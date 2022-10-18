//
//  SceneDelegate.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 20/06/2021.
//

import UIKit
import Siren

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        checkIsLoggedBefore()
        window?.makeKeyAndVisible()
        
        if let userActivity = connectionOptions.userActivities.first,
            let url = userActivity.webpageURL {
            DeepLinkingNavigator.shared.parse(link: url.absoluteString)
        }
        
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .critical,
                                          showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
    
        Siren.shared.wail()
    }
    
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL else {
            return
        }
        DeepLinkingNavigator.shared.parse(link: url.absoluteString)
    }

    
    private func checkIsLoggedBefore() {
        if !isAppAlreadyLaunchedOnce() {
            let navigationController = UINavigationController(rootViewController: IntroVC())
            navigationController.navigationBar.isHidden = true
            window?.rootViewController = navigationController
        }else if let token = UserDefaultsManager.shared.getStringForKey(key: .token), token != "" {
            window?.rootViewController = MainTabBarController()
        }else {
            let nc = UINavigationController(rootViewController: LoginVC())
            nc.navigationBar.isHidden = true
            window?.rootViewController = nc
        }
    }
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
            return true
        } else {
            //defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}

