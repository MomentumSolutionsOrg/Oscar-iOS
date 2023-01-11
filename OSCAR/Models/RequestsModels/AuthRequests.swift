//
//  AuthRequests.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 29/06/2021.
//

import Foundation

struct SignUpParams: RequestParameters {
    var name: String
    var phone: String
    var email: String
    var password: String
    var passwordConfirmation: String
    var referralID: String? 
    
    
    private enum CodingKeys: String, CodingKey {
        case name
        case phone, email, password
        case passwordConfirmation = "password_confirmation"
        case referralID = "referral_id"
    }
}

struct LoginParams:RequestParameters {
    let email:String
    let password:String
}

struct ContactUsParams: RequestParameters {
    let email: String
    let firstName: String
    let lastName: String
    let message: String
    private enum CodingKeys: String, CodingKey {
        case email,message
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
