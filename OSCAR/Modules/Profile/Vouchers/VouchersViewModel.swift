//
//  VouchersViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 05/08/2021.
//

import Foundation

class VouchersViewModel: BaseViewModel {
    
    var successCompletion: (() -> Void)?
    private(set) var vouchers = [Voucher]()
    
    func fetchVouchers() {
        startRequest(request: OffersApi.getVouchers, mappingClass: BaseModel<[Voucher]>.self) { [weak self] response in
            self?.vouchers = response?.data ?? []
            self?.successCompletion?()
        }
    }
}
