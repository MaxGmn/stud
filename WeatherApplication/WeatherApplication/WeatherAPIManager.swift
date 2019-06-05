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
    
    static func myRequest(_ locationType: SearchLocationType) {
        let urlComponents = getURLComponents(by: locationType)
        request(urlComponents).responseJSON { (response) in
            if let data = response.data {
                if let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    print(weather)
                }
            }
        }
    }
}

private extension WeatherAPIManager {
    
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5/weather"
    static let measure = "metric"
    static let APIKey = "60c8af5ef53edf7cf9e4b2fa2bda99b7"
    
    static func getURLComponents(by locationType: SearchLocationType) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        var queryParameters = [URLQueryItem]()
        for parameter in locationType.getParameters {
            queryParameters.append(URLQueryItem(name: parameter.key, value: parameter.value))
        }
        queryParameters += [URLQueryItem(name: "units", value: measure), URLQueryItem(name: "appid", value: APIKey)]
        urlComponents.queryItems = queryParameters
        return urlComponents
    }
}

enum SearchLocationType {
    case byCityName(q: String)
    case byCityID(id: Int)
    case byGeographicCoordinates(lat: Int, lon: Int)
    case byZipCode(zip: String)
    
    var getParameters: [(key: String, value: String)] {
        switch self {
        case .byCityName(let q):
            return [(key: "q", value: q)]
        case .byCityID(let id):
            return [(key: "id", value: String(id))]
        case .byGeographicCoordinates(let lat, let lon):
            return [(key: "lat", value: String(lat)), (key: "lon", value: String(lon))]
        case .byZipCode(let zip):
            return [(key: "zip", value: zip)]
        }
    }
}
