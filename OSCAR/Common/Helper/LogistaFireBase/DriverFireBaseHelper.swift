//
//  DriverFireBaseHelper.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import FirebaseDatabase

class DriverFireBaseHelper {
    static let shared = DriverFireBaseHelper()
    private let usersRef = Database.database().reference().child("users")
    private init() {}
    
    func observeDriver(for user: String, with id: String, completion: @escaping (Result<LogistaDriver,Error>) -> Void) {
        removeObservers()
        usersRef.child(user).child("drivers").child(id).observe(.value) { (snapshot) in
            guard let driverDictionary = snapshot.value as? [String:Any] else {
                completion(.failure(MyError.unknown))
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: driverDictionary, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let logistaDriver = try decoder.decode(LogistaDriver.self, from: data)
                completion(.success(logistaDriver))
            }catch {
                completion(.failure(error))
                print(error)
                return
            }
        }
    }
    
    func removeObservers() {
        usersRef.removeAllObservers()
    }
}
