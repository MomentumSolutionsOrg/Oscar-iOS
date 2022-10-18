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
    let id: Int?
    let name, email: String?
    let verified, defaultAddress: Int?
    let phone: String?
    let videoPoints: Int?
    let image: String?
    let accountNo: String?
    let referralID: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, verified
        case defaultAddress = "default_address"
        case phone
        case videoPoints = "video_points"
        case image = "image_url"
        case accountNo = "account_no"
        case referralID = "referral_id"
    }
}
