//
//  RequestParamters.swift
//  OSCAR
//
//  Created by Hussein Kishk on 5/19/20.
//  Copyright © 2020 Hussein Kishk. All rights reserved.
//

import UIKit

protocol RequestParameters: Codable {
    func getParamsAsJson() -> [String: Any]
}

extension RequestParameters {
    func getParamsAsJson() -> [String: Any] {
        let jsonEncoder = JSONEncoder()

        guard let jsonData = try? jsonEncoder.encode(self) else {
            return [:]
        }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        debugPrint(dictionary)
        return dictionary
    }
}
