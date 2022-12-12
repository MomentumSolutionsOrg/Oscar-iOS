//
//  BaseViewModel.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 11/05/2021.
//

import Foundation
import PromiseKit

public enum State {
    case loading
    case error
    case empty
    case populated
}

class BaseViewModel: NSObject {
    private let api = Api()
    var updateLoadingStatus: (()->())?
    var updateError: ((String)->())?
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var checkInternetConnection: (() -> ())?
    
    func startRequest<M: Codable>(request: Requestable, mappingClass: M.Type,successCompletion: @escaping((M?) -> Void), showLoading: Bool = true) {
        
        if request.path.contains("products/0?"){
            return
        }
        
        if showLoading {
            state = .loading
        }
        
        api.fireRequestWithSingleResponse(urlConvertible: request, mappingClass: M.self).done {[weak self] success in
            self?.state = .populated
            successCompletion(success)
        }.catch {[weak self] error in
            self?.state = .error
            self?.updateError?((error as? MyError)?.message.localized ?? error.localizedDescription.description)
        }
    }
    
    func uploadMultipart<M: Codable>(request: Requestable, mappingClass: M.Type, successCompletion: @escaping((M?) -> Void)) {
        state = .loading
        api.fireMultipartRequest(urlConvertible: request, mappingClass: M.self).done {[weak self] success in
            self?.state = .populated
            successCompletion(success)
        }.catch {[weak self] error in
            self?.state = .error
            self?.updateError?((error as? MyError)?.message.localized ?? error.localizedDescription.description)
        }
    }
}
