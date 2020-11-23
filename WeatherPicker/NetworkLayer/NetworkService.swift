//
//  NetworkService.swift
//  WearPicker
//
//  Created by Madara2hor on 16.11.2020.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func getWeather(city: String,
                    completion: @escaping (Result<WeatherResponse?, Error>) -> Void)
    func getWeatherByUserLocation(lat: Double,
                                  lon: Double,
                                  completion: @escaping (Result<WeatherResponse?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    static let networkInstance = NetworkService()
    var apiKey: String = "7a3da769d5a2e5f1bf2e9a78c5d30c00"
    var apiURL: String = "http://api.openweathermap.org/data/2.5/"
    
    func getWeather(city: String,
                    completion: @escaping (Result<WeatherResponse?, Error>) -> Void) {
        
        let parameters = ["q": "\(city)", "appid": apiKey, "lang": "en", "units": "metric"]
        let urlString = getUrlString(endpoint: apiEndpoint.weather.rawValue, parameters: parameters)
        
        fetchData(type: WeatherResponse.self, urlString: urlString) { result in
            completion(result)
        }
    }
    
    func getWeatherByUserLocation(lat: Double,
                                  lon: Double,
                                  completion: @escaping (Result<WeatherResponse?, Error>) -> Void) {
        
        let parameters = ["lat": "\(lat)", "lon": "\(lon)", "appid": apiKey, "lang": "en", "units": "metric"]
        let urlString = getUrlString(endpoint: apiEndpoint.weather.rawValue, parameters: parameters)
        print(urlString)
        fetchData(type: WeatherResponse.self, urlString: urlString) { result in
            completion(result)
        }
    }
    
    func getUrlString(endpoint: String, parameters: [String: String]) -> String {
        var parametersString = String()
        
        
        for (key, value) in parameters {
            parametersString += "\(key)=\(value)&"
        }
        
        let hashedUrlString = "\(apiURL)\(endpoint)?\(parametersString)"
        
        return hashedUrlString
    }
    
    func fetchData<T: Decodable>(type: T.Type = T.self, urlString: String, completion: @escaping (Result<T?, Error>) -> Void) {
        AF.request(urlString)
            .downloadProgress { progress in
                print(progress.fractionCompleted)
            }
            .responseDecodable(of: T.self) { response in
                do {
                    let obj = try JSONDecoder().decode(T.self, from: response.data!)
                    completion(.success(obj))
                } catch {
                    completion(.failure(response.error!))
                }
            }
    }

}

struct apiParameters {
    let q: String
    let apiKey: String
    let lang: String?
    
}

enum apiEndpoint: String {
    case weather = "weather"
}
