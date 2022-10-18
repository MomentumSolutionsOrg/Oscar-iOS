//
//  TrackOrderViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import Foundation

class TrackOrderViewModel: BaseViewModel {
    
    var order: Order?
    
    var shippingLongitude: Double = 31.45159272596574
    var shippingLatitude: Double = 30.003042222161117
    
    var driverLongitude: Double = 0.0
    var driverLatitude: Double = 0.0
    
    var driverID = "1"
    
    
    func trackOrder(completion: @escaping (Error?) -> Void ) {
        OrderFireBaseHelper.shared.getOrder(for: order?.logistaUserID ?? "1", with: order?.logistaOrderID ?? "1") { [weak self] response in
            switch response {
            case .success(let order):
                self?.shippingLatitude = Double(order.delivery?.address?.lat ?? "0.0") ?? 0.0
                self?.shippingLongitude = Double(order.delivery?.address?.lng ?? "0.0") ?? 0.0
                self?.driverID = order.driverId ?? "1"
                self?.observeDriverCoordinates(completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func observeDriverCoordinates(completion: @escaping (Error?) -> Void) {
        DriverFireBaseHelper.shared.observeDriver(for: order?.logistaUserID ?? "", with: driverID) {  [weak self] response in
            switch response {
            case .success(let driver):
                self?.driverLatitude = driver.currantLatitude  ?? 0.0
                self?.driverLongitude = driver.currantLongitude  ?? 0.0
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
}
