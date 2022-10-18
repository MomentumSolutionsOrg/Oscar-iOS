//
//  UpdateProfileParameters.swift
//  OSCAR
//
//  Created by Mostafa Samir on 03/08/2021.
//

import Foundation

struct UpdateProfileParameters: RequestParameters {
    let image: Data?
    let name: String?
    let email: String?
}
