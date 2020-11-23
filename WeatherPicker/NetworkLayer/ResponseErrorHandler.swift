//
//  ErrorHandler.swift
//  WearPicker
//
//  Created by Madara2hor on 17.11.2020.
//

import Foundation

enum ResponseErrorHandelr: String{
    case incorrectFormat = "The data couldn’t be read because it isn’t in the correct format."
    case cityNotFound = "city not found"
    case wrongAPIKey = "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info."
}
