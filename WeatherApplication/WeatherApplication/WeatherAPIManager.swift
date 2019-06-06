//
//  WeatherAPIManager.swift
//  WeatherApplication
//
//  Created by Maksym Humeniuk on 6/4/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation
import Alamofire

class WeatherAPIManager {
    
    static func myRequest(_ weatherDataType: WeatherDataType, handler: @escaping (WeatherData) -> Void) {
        guard let url = getURL(by: weatherDataType) else { return }
        
        // URLSession
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let receivedData = data {
                switch weatherDataType {
                case .current:
                    if let currentWeather = try? JSONDecoder().decode(CurrentWeatherData.self, from: receivedData) {
                        handler(currentWeather)
                    }
                case .fiveDay:
                    if let dailyWeather = try? JSONDecoder().decode(FiveDayWeatherData.self, from: receivedData) {
                        handler(dailyWeather)
                    }
                }
            }
        }.resume()
        
        // Alamofire
        request(url).responseJSON { (response) in
            if let data = response.data {
                switch weatherDataType {
                case .current:
                    if let currentWeather = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) {
                        handler(currentWeather)
                    }
                case .fiveDay:
                    if let dailyWeather = try? JSONDecoder().decode(FiveDayWeatherData.self, from: data) {
                        handler(dailyWeather)
                    }
                }
            }
        }
    }
}

private extension WeatherAPIManager {
    
    static let measure = "metric"
    static let APIKey = "60c8af5ef53edf7cf9e4b2fa2bda99b7"
    
    static func getURL(by weatherDataType: WeatherDataType) -> URL? {
        guard var urlComponents = URLComponents(string: weatherDataType.getURLPath) else { return nil }
        urlComponents.queryItems = weatherDataType.getURLParameters + [URLQueryItem(name: "units", value: measure), URLQueryItem(name: "appid", value: APIKey)]
        return urlComponents.url
    }
}

enum WeatherDataType {
    case fiveDay(searchLocationType: SearchLocationType)
    case current(searchLocationType: SearchLocationType)
    
    var getURLParameters: [URLQueryItem] {
        switch self {
        case .fiveDay(let type):
            return type.getURLParameters
        case .current(let type):
            return type.getURLParameters
        }
    }
    
    var getURLPath: String {
        switch self {
        case .fiveDay:
            return "https://api.openweathermap.org/data/2.5/forecast"
        case .current:
            return "https://api.openweathermap.org/data/2.5/weather"
        }
    }
}

enum SearchLocationType {
    case byCityName(q: String)
    case byCityID(id: Int)
    case byGeographicCoordinates(lat: Int, lon: Int)
    case byZipCode(zip: String)
    
    var getURLParameters: [URLQueryItem] {
        switch self {
        case .byCityName(let q):
            return [URLQueryItem(name: "q", value: q)]
        case .byCityID(let id):
            return [URLQueryItem(name: "id", value: String(id))]
        case .byGeographicCoordinates(let lat, let lon):
            return [URLQueryItem(name: "lat", value: String(lat)), URLQueryItem(name: "lon", value: String(lon))]
        case .byZipCode(let zip):
            return [URLQueryItem(name: "zip", value: zip)]
        }
    }
}
