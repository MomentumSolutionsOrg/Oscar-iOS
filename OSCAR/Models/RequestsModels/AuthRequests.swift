//
//  AuthRequests.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 29/06/2021.
//

import Foundation

struct SignUpParams: RequestParameters {
    let name:String
    let phone:String
    let email:String
    let password:String
    let referralId:String
    
    private enum CodingKeys: String, CodingKey {
        case name,phone,email,password
        case referralId = "referral_id"
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
