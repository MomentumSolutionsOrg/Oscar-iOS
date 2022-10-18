//
//  DateExtension.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 24/05/2021.
//

import Foundation

extension Date {
    func convertDateToString(format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
