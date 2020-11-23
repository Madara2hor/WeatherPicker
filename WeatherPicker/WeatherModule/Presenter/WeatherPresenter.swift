//
//  ViewModel.swift
//  WearPicker
//
//  Created by Madara2hor on 16.11.2020.
//

import Foundation
import CoreLocation

protocol WeatherViewPresenterProtocol: class {
    var weather: WeatherResponse? { get }
    var userLocation: CLLocation? { get set }
    var searchedCity: String? { get set }
    init(view: WeatherViewProtocol)
    
    func getWeather()
    func getWeatherByUserLocation()
}

protocol AlertPresenterProtocol {
    func presentLocationPremissionAlert()
}

protocol WeatherViewProtocol: class, AlertPresenterProtocol {
    func success()
    func failure(error: String?)
}

class WeatherPresenter: WeatherViewPresenterProtocol {
    
    var userLocation: CLLocation?
    
    private var locationManager: CLLocationManager?
    let networkService: NetworkServiceProtocol!
    weak var view: WeatherViewProtocol?
    
    var weather: WeatherResponse?
    var searchedCity: String?
    
    
    required init(view: WeatherViewProtocol) {
        self.view = view
        networkService = NetworkService.networkInstance
        setupUserLocation()
    }
    
    private func setupUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.delegate = view as? CLLocationManagerDelegate
        
    }
    
    func getWeatherByUserLocation() {
        let status = locationManager?.authorizationStatus
        
        switch(status) {
            case .authorizedAlways, .authorizedWhenInUse:
                if userLocation == nil { return }
                
                networkService.getWeatherByUserLocation(lat: userLocation!.coordinate.latitude, lon: userLocation!.coordinate.longitude) { [weak self] result in
                    guard self != nil else { return }
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let requsetResult):
                                switch requsetResult?.cod {
                                case 200:
                                    self?.weather = requsetResult
                                    
                                    self?.view?.success()
                                default:
                                    self?.weather = nil
                                    self?.view?.failure(error: requsetResult?.message)
                                }
                            case .failure(let error):
                                self?.view?.failure(error: error.localizedDescription)
                        }
                    }
                }
            case .notDetermined, .restricted, .denied:
                DispatchQueue.main.async {
                    self.view?.presentLocationPremissionAlert()
                }
        default:
            break
        }
    }
    
    func getWeather() {
        networkService.getWeather(city: searchedCity ?? "") { [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let requsetResult):
                        switch requsetResult?.cod {
                        case 200:
                            self?.weather = requsetResult
                            
                            self?.view?.success()
                        default:
                            self?.weather = nil
                            self?.view?.failure(error: requsetResult?.message)
                        }
                    case .failure(let error):
                        self?.view?.failure(error: error.localizedDescription)
                }
            }
        }
    }
    
    
}
