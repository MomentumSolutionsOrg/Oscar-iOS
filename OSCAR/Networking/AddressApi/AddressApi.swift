//
//  AddressApi.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import Alamofire

enum AddressPaths {
    static let getAddresses = "address/get"
    static let updateAddress = "address/update_new/"
    static let deleteAddress = "address/delete/"
    static let addAddress = "address/add_new"
    
}

enum AddressApi: Requestable {
    
    case getAddresses
    case updateAddress(addressId: Int, parameters: AddressParameters)
    case deleteAddress(addressId: Int)
    case addAddress(parameters: AddressParameters)
    
    var path: String {
        switch self {
        case .getAddresses:
            return AddressPaths.getAddresses
        case .updateAddress(let addressId, _):
            return AddressPaths.updateAddress + addressId.description
        case .deleteAddress(let addressId):
            return AddressPaths.deleteAddress + addressId.description
        case .addAddress:
            return AddressPaths.addAddress
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAddresses:
            return .get
        default :
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getAddresses:
            return nil
        case .updateAddress(_ , let parameters):
            return parameters.getParamsAsJson()
        case .deleteAddress:
            return nil
        case .addAddress(let parameters):
            return parameters.getParamsAsJson()
        }
    }
    
    var isWWWFormUrlEncoded: Bool? {
        switch self {
        case .getAddresses:
            return false
        case .updateAddress:
            return true
        case .deleteAddress:
            return false
        case .addAddress:
            return true
        }
    }
}
