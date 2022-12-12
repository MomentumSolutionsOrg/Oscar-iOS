//
//  AppDelegate.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 20/06/2021.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseAuth
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import Siren
import FirebaseInstallations
//import FacebookCore
//import AppTrackingTransparency
//import FBAudienceNetwork
//import AdSupport


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Utils.initLibraries()
        LanguageManager.shared.changeSemanticContentAttribute()
        NetworkMonitor.shared.startMonitoring()
        setupPushNotifications(for: application)
//        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        window = UIWindow(frame: UIScreen.main.bounds)
        checkIsLoggedIn()
        window?.makeKeyAndVisible()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
//                 self?.requestTracking()
//             }
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .default,
                                          showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
    
        Siren.shared.wail()
        
     
   
        return true
    }
    
//    func requestTracking(){
//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization(completionHandler: { (status) in
//                switch status{
//                case .authorized:
//                    FBAdSettings.setAdvertiserTrackingEnabled(true)
//                    Settings.isAutoLogAppEventsEnabled = true
//                    Settings.isAdvertiserIDCollectionEnabled = true
//                    break
//
//                case .denied:
//                    FBAdSettings.setAdvertiserTrackingEnabled(false)
//                    Settings.isAutoLogAppEventsEnabled = false
//                    Settings.isAdvertiserIDCollectionEnabled = false
//
//                    break
//                default:
//                    break
//                }
//            })
//        }
//    }
    
//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//            ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//
//    }
    
    private func checkIsLoggedIn() {
        CurrentUser.shared.defaultPaymentType = UserDefaultsManager.shared.getIntForKey(key: .paymentType) ?? 0
        
        CurrentUser.shared.checkListCount = UserDefaultsManager.shared.getIntForKey(key: .checkListCount) ?? 0
        if let store = UserDefaultsManager.shared.getStringForKey(key: .storeId) {
            CurrentUser.shared.store = store
        }
        if !isAppAlreadyLaunchedOnce() {
            let navigationController = UINavigationController(rootViewController: IntroVC())
            navigationController.navigationBar.isHidden = true
            window?.rootViewController = navigationController
        }else if let token = UserDefaultsManager.shared.getStringForKey(key: .token),token != "" {
            CurrentUser.shared.token = token
            CurrentUser.shared.user = UserDefaultsManager.shared.getUser()
            window?.rootViewController = MainTabBarController()
        }else {
            let navigationController = UINavigationController(rootViewController: LoginVC())
            navigationController.navigationBar.isHidden = true
            window?.rootViewController = navigationController
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
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb
            ,let url = userActivity.webpageURL else {
            return false
        }
        DeepLinkingNavigator.shared.parse(link: url.absoluteString)
        return true
    }
}

extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? "" ]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"),
                                        object: nil, userInfo: dataDict)
        
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.

        if let fcmToken = fcmToken {
            UserDefaultsManager.shared.saveInUserDefault(key: .fCMToken, data: fcmToken)
            Utils.updateNotificationToken()
        }
        
        Messaging.messaging()
            .subscribe(toTopic: Constants.NotificationTopic.oscarNotifyiOS.rawValue) { error in
                    if error == nil {
                        print("Subscribed to topic")

                    } else {
                        print("Not Subscribed to topic")
                    }
                }

    }
}

extension AppDelegate : UNUserNotificationCenterDelegate{
    func setupPushNotifications(for application: UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)

    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([.alert,.sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
 
        
        if userInfo["attachment"] != nil{
            
            let yyy = userInfo["aps"] as? [String:Any]
            let xxx = yyy?["alert"] as? [String:Any]
            
            let image = userInfo["attachment"] as? String ?? ""
            let title = xxx?["title"] as? String ?? ""
            let subTitle = xxx?["body"] as? String ?? ""
            let link = userInfo["link"] as? String ?? ""
      
            let notificationObj = NotificationObject(title: title, subTitle: subTitle, image: image, link: link)
            do {
                try UserDefaultsManager.shared.setObject(notificationObj, forKey: .notification)
            } catch {
                print(error.localizedDescription)
            }
            UserDefaultsManager.shared.saveInUserDefault(key: .notification,
                                                         data: "LocalDataNotification")
        } else {
           
            if let uid = userInfo["url"] as? String {
                
                DeepLinkingNavigator.shared.parse(link: uid)
                
            }
        }
        
        completionHandler()
    }
}



