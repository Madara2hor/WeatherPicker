//
//  WeatherResponseModel.swift
//  WearPicker
//
//  Created by Madara2hor on 16.11.2020.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: Coordinates?
    let weather: [Weather]?
    let base: String?
    let main: MainInfo?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int
    let message: String?
}

struct Coordinates: Codable {
    let lon: Float
    let lat: Float
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainInfo: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Codable {
    let speed: Float
    let deg: Int
    let gust: Float?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let message: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}
