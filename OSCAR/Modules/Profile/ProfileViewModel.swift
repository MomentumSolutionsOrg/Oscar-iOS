//
//  ProfileViewModel.swift
//  OSCAR
//
//  Created by Asmaa Tarek on 27/06/2021.
//

import Foundation

class ProfileViewModel: BaseViewModel {
    
    var logoutCompletion: (()->())?
    var userProfileCompletion: (()->())?
    var updateProfileCompletion: ((String) -> Void )?
    var user: User?
    
    private(set) var profileItems: [Constants.ProfileItems] = [.barcode,.orders,.voucher,.address]
    
    func logout() {
        startRequest(request: AuthApi.logout, mappingClass: MessageModel.self) { [weak self] _ in
            self?.logoutCompletion?()
        }
    }
    
    func getUserProfule() {
        startRequest(request: AuthApi.userProfile,
                     mappingClass: BaseModel<User>.self) { [weak self] response in
            self?.user = response?.data
            self?.userProfileCompletion?()
        }
    }
    
    func updateProfile(with parameters: UpdateProfileParameters) {
        uploadMultipart(request: AuthApi.updateProfile(parameters: parameters), mappingClass: BaseModel<User>.self) { [weak self] response in
            if let user = response?.data {
                Utils.saveUser(user: user)
                self?.updateProfileCompletion?("profile_updated_successfully".localized)
            }else {
                self?.updateProfileCompletion?("general_error".localized)
            }
        }
    }
    
    func getLastOrder(completion: @escaping (Order?,Error?) -> Void) {
        Api().fireRequestWithSingleResponse(urlConvertible: OrdersApi.getLastOrder, mappingClass: BaseModel<Order>.self).get { [weak self] response in
            if let order = response.data {
                self?.getOrderStatus(for: order, completion: completion)
            }else {
                completion(nil,MyError.unknown)
            }
        }.catch { error in
            completion(nil,error)
        }
    }
    
    private func getOrderStatus(for order: Order,completion: @escaping (Order?,Error?) -> Void) {
        OrderFireBaseHelper.shared.getOrder(for: order.logistaUserID ?? "Zhlh9jyNCtTmWh8MeKJwSB3QYBp2", with: order.logistaOrderID ?? "0") { result in
            switch result {
            case .success(let logistaOrder):
                if logistaOrder.status == 3 {
                    completion(order,nil)
                }else {
                    completion(nil,nil)
                }
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
}
