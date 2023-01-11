//
//  LoginResponse.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 29/06/2021.
//

import Foundation

struct LoginResponse: Codable {
    let token, tokenType: String?
    let expiresIn: Int?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case token
        case tokenType = "type"
        case expiresIn = "expires"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let id, main, relID, employeeID: Int?
    let name, phone: String?
    let address, city, region, country: String?
    let postbox: String?
    let email: String?
    let picture, company, taxid, nameS: String?
    let phoneS, emailS, addressS, cityS: String?
    let regionS, countryS, postboxS: String?
    let balance: String?
    let docid, custom1: String?
    let ins, active: Int?
    let password: String
    let roleID: Int?
    let rememberToken: String?
    let createdAt, updatedAt, referralID, accountNo: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case relID = "rel_id"
        case employeeID = "employee_id"
        case name, phone, address, city, region, country, postbox, email, picture, company, taxid
        case nameS = "name_s"
        case phoneS = "phone_s"
        case emailS = "email_s"
        case addressS = "address_s"
        case cityS = "city_s"
        case regionS = "region_s"
        case countryS = "country_s"
        case postboxS = "postbox_s"
        case balance, docid, custom1, ins, active, password
        case roleID = "role_id"
        case rememberToken = "remember_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case referralID = "referral_id"
        case accountNo = "account_no"
    }
}

