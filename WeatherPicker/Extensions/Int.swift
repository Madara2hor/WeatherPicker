//
//  Int.swift
//  WearPicker
//
//  Created by Madara2hor on 16.11.2020.
//

import Foundation

extension Int {
    static func getNonOptionalString(value: Int?) -> String {
        guard let nonOptionalValue = value else {
            return ""
        }
        return "\(nonOptionalValue)"
    }
    
    static func convertIntToDateString(value: Int?) -> String {
        guard let dateValue = value else {
            return ""
        }
        let truncatedTime = Int(dateValue)
        let date = Date(timeIntervalSince1970: TimeInterval(truncatedTime))
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
