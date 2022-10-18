//
//  UserDefaultsManager.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 15/06/2021.
//

import Foundation

class UserDefaultsManager {
    static let shared =  UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    private init() {}
    
    func saveInUserDefault(key: Constants.UserDefaultKeys, data: Any) {
        userDefaults.setValue(data, forKey: key.rawValue)
    }
    
    func getStringForKey(key: Constants.UserDefaultKeys) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
    
    func getIntForKey(key: Constants.UserDefaultKeys) -> Int? {
        return userDefaults.integer(forKey: key.rawValue)
    }
    
    func setObject<Object>(_ object: Object, forKey: Constants.UserDefaultKeys) throws where Object: Encodable {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(object)
                userDefaults.set(data, forKey: forKey.rawValue)
            } catch {
                throw ObjectSavableError.unableToEncode
            }
        }
        
    func getObject<Object>(forKey: Constants.UserDefaultKeys, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = userDefaults.data(forKey: forKey.rawValue) else { throw ObjectSavableError.noValue }
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(type, from: data)
                return object
            } catch {
                throw ObjectSavableError.unableToDecode
            }
        }
    
    func removeObject(forKey: Constants.UserDefaultKeys) {
            UserDefaults.standard.removeObject(forKey: forKey.rawValue)
        }
    
    func saveUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaultKeys.userData.rawValue)
        }
    }
    
    func getUser() -> User? {
        
        guard let user = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.userData.rawValue) as? Data else {return nil}
        guard let loadedUser = try? JSONDecoder().decode(User.self, from: user) else { return nil}
        return loadedUser
    }
    
    func removeLocalData() {
        Constants.UserDefaultKeys.allCases.forEach { key in
            if key != Constants.UserDefaultKeys.storeId {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
        CurrentUser.shared.token = nil
        CurrentUser.shared.user = nil
        //logOut?()
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
