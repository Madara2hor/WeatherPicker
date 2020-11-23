//
//  Float.swift
//  WearPicker
//
//  Created by Madara2hor on 16.11.2020.
//

import Foundation

extension Float {
    static func getNonOptionalString(value: Float?) -> String {
        guard let nonOptionalValue = value else {
            return ""
        }
        return "\(nonOptionalValue)"
    }
}
