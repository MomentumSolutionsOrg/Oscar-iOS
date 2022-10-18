//
//  NotificationObject.swift
//  OSCAR
//
//  Created by Mostafa Samir on 05/01/2022.
//

import Foundation

// MARK: - NotificationObject
struct NotificationObject: Codable {
    let title, subTitle: String
    let image: String
    let link: String
}
