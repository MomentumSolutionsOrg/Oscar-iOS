//
//  MyError.swift
//  OSCAR
//
//  Created by Mostafa Samir on 9/8/20.
//

import Foundation

public enum MyError: Error {
    var message:String {
        switch self {
        case .noInternet:
            return "check_internet_connection".localized
        case .badAPIRequest:
            return "bad_api_request".localized
        case .unauthorized(message: let message):
            return message
        case .unknown:
            return "unexpected_error_occured".localized
        case .serverError:
            return "canot_connect_to_server".localized
        case .timeout:
            return "connection_timedout".localized
        }
    }
    // MARK: - Internal errors
    case noInternet
    // MARK: - API errors
    case badAPIRequest
    // MARK: - Auth errors
    case unauthorized(message:String)
    // MARK: - Unknown errors
    case unknown
    case serverError
    case timeout
    
}

