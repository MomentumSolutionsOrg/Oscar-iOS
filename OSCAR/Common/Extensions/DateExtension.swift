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
    
    

    func isClosingTime() -> Bool {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second,
                                                    value: Int(timeZoneOffset), to: nowUTC) else {return false}
        
        let dateFormatter = DateFormatter()
         dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a"
        let closingTime = dateFormatter.date(from: Constants.closingDeliveryTime)
        guard let closingTime = closingTime else {return false}
        
        return Calendar.current.isDate(closingTime, equalTo: localDate, toGranularity: .hour)

    }
}

