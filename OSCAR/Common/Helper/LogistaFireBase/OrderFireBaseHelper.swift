//
//  OrderFireBaseHelper.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import FirebaseDatabase



class OrderFireBaseHelper {
    static let shared = OrderFireBaseHelper()
    private let usersRef = Database.database().reference().child("users")
    private init() {}
    
    func getOrder(for user: String, with id: String, completion: @escaping (Result<LogistaOrder,Error>) -> Void) {
        usersRef.child(user).child("tasks").child(id).observeSingleEvent(of: .value) { (snapshot) in
            guard let orderDictionary = snapshot.value as? [String:Any] else {
                completion(.failure(MyError.unknown))
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: orderDictionary, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let logistaOrder = try decoder.decode(LogistaOrder.self, from: data)
                completion(.success(logistaOrder))
            }catch {
                completion(.failure(error))
                print(error)
                return
            }
        }
    }
}

