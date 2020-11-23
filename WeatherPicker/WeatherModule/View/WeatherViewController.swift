//
//  ViewController.swift
//  WearPicker
//
//  Created by Madara2hor on 16.11.2020.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var wearIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var visability: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    @IBOutlet weak var locationButton: UIButton!
    
    var presenter: WeatherViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        self.overrideUserInterfaceStyle = .dark
        
        presenter = WeatherPresenter(view: self)
        setWeatherDataVisability(isHidden: true)
        self.background.setBlurView()
        self.locationButton.makeCircle()
        self.locationButton.makeTransparent(color: UIColor.buttonColor)
    }
    
    @IBAction func setUserLocation(_ sender: Any) {
        presenter?.searchedCity = nil
        presenter?.getWeatherByUserLocation()
    }
    
    func setWeatherDataVisability(isHidden: Bool){
        wearIcon.isHidden = isHidden
        weatherDescription.isHidden = isHidden
        temperature.isHidden = isHidden
        feelsLike.isHidden = isHidden
        wind.isHidden = isHidden
        clouds.isHidden = isHidden
        visability.isHidden = isHidden
        sunrise.isHidden = isHidden
        sunset.isHidden = isHidden
    }

}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cleanText = searchText.replacingOccurrences(of: " ", with: "")
        searchBar.text = cleanText
        if cleanText == "" {
            presenter?.searchedCity = nil
        } else {
            presenter?.searchedCity = cleanText.lowercased()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard presenter?.searchedCity == nil else {
            presenter?.getWeather()
            searchBar.text = ""
            view.endEditing(true)
            return
        }
        view.endEditing(true)
    }

}

extension WeatherViewController: WeatherViewProtocol {
    func presentLocationPremissionAlert() {
        self.present(UIAlertController.locationPremissionAlert, animated: true, completion: nil)
    }
    
    
    func success() {
        setWeatherDataVisability(isHidden: false)
        cityLabel.text = presenter?.weather?.name
        if let weather = presenter?.weather,
           let currenWeather = weather.weather,
           let urlImage = URL(string: "http://openweathermap.org/img/wn/\(currenWeather[0].icon)@4x.png") {
            wearIcon.load(url:urlImage)
        }
        weatherDescription.text = presenter?.weather?.weather?[0].description
        
        let temp = Int(round((presenter?.weather?.main!.temp)!))
        temperature.text = "\(temp)°C"
        let feelsTemp = Int(round((presenter?.weather?.main!.feels_like)!))
        feelsLike.text = "feels like \(feelsTemp)°C"
        wind.text = "Wind: \(Float.getNonOptionalString(value: presenter?.weather?.wind?.speed)) m/s"
        clouds.text = "Clouds: \(Int.getNonOptionalString(value: presenter?.weather?.clouds?.all))%"
        visability.text = "Visability: \(Int.getNonOptionalString(value: (presenter?.weather?.visibility)! / 100))%"
        sunrise.text = "Sunrise: \(Int.convertIntToDateString(value: presenter?.weather?.sys?.sunrise))"
        sunset.text = "Sunset: \(Int.convertIntToDateString(value: presenter?.weather?.sys?.sunset))"
    }
    
    func failure(error: String?) {
        switch error {
        case ResponseErrorHandelr.incorrectFormat.rawValue, ResponseErrorHandelr.cityNotFound.rawValue:
            cityLabel.text = "City not found.."
        case ResponseErrorHandelr.wrongAPIKey.rawValue:
            cityLabel.text = "Probably my API key is gone. It's app useless now..."
        default:
            cityLabel.text = "Search any city you want"
        }
        
        setWeatherDataVisability(isHidden: true)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, presenter?.searchedCity == nil {
            presenter?.userLocation = location
            presenter?.getWeatherByUserLocation()
        }
    }
}

