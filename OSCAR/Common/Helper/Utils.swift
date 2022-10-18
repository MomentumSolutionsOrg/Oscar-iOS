//
//  Utils.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 10/05/2021.
//

import Firebase
import IQKeyboardManagerSwift
import RealmSwift
import SDWebImageWebPCoder
class Utils {
    
    class func initLibraries() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "done".localized
        
        // support .webp extension in images fro iOS < 14
        if #available(iOS 14, *) {
        }else {
            SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
        }
        FirebaseApp.configure()
        let configuration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                }
            }
        )
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    class func saveUserData(response: LoginResponse?) {
        if let token = response?.token {
            UserDefaultsManager.shared.saveInUserDefault(key: .token, data: token)
            CurrentUser.shared.token = token
        }
        if let user = response?.user {
          saveUser(user: user)
        }        
    }
    
    class func saveUser(user: User) {
        CurrentUser.shared.user = user
        UserDefaultsManager.shared.saveUser(user: user)
    }
    
    class func updateNotificationToken() {
        if let fCMToken = UserDefaultsManager.shared.getStringForKey(key: .fCMToken) {
//            if let _ = UserDefaultsManager.shared.getStringForKey(key: .token) {
            
                Api().fireRequestWithSingleResponse(urlConvertible: AuthApi.fcmToken(token: fCMToken), mappingClass: MessageModel.self).get { response in
                    print(response.message, "workedddd!!!")
                }.catch { error in
                    debugPrint(error.localizedDescription)
                }
//            }
        }
    }
    
    class func checkCart() {
        if CurrentUser.shared.token != nil {
            Api().fireRequestWithSingleResponse(urlConvertible: CheckoutProcessApi.getCart, mappingClass: BaseModel<[Product]>.self).get { response in
                guard let products = response.data else { return }
                let totalCost = products
                    .compactMap { $0.total }
                    .reduce(0.0) { $0 + $1 }
                let count = response.data?.count ?? 0
                
                CurrentUser.shared.cartCount = count
                CurrentUser.shared.cartTotal = totalCost
            }.catch { error in
                print(error)
            }
        }
    }
    
    class func shareProduct(with id:String) {
        let items = ["https://www.oscarstores.com/en/show_product/\(id)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(ac)
        }
    }
    
    class func defaultCoordinate() -> String {
        switch CurrentUser.shared.store {
        case "01":// Heliopolis
            return "30.0872215,31.3478606"
        case "02": // 5th Settlement
            return "30.027679,31.4908344"
        case "04":// Zamalek
            return "30.060472,31.2234871"
        case "05":// Maadi
            return "29.9607097,31.2952341"
        default:
            return "30.0872215,31.3478606"
            
        }
    }
}
