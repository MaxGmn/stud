//
//  Weather.swift
//  WeatherApplication
//
//  Created by Maksym Humeniuk on 6/4/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

protocol WeatherData {}

// main structures
struct CurrentWeatherData: WeatherData, Codable {
    let id: Int
    let name: String
    let cod: Int
    let base :String
    let timezone: Int?
    let visibility: Int?
    let dt: Int?
    let coord: Coord?
    let weather: [WeatherInfo]?
    let main: MainInfo?
    let wind: Wind?
    let clouds: Clouds?
    let sys: Sys?
    let rain: Rain?
    let snow: Snow?
}

struct FiveDayWeatherData: WeatherData, Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let city: City?
    let list: [WeatherList]?
}

// accessory structures
struct City: Codable {
    let id: Int?
    let name: String?
    let country: String?
    let coord: Coord?
}

struct WeatherList: Codable{
    let dt: Int?
    let dtTxt: String?
    let main: MainInfo?
    let weather: [WeatherInfo]?
    let clouds: Clouds?
    let wind: Wind?
    let rain: Rain?
    let snow: Snow?
    
    enum CodingKeys: String, CodingKey {
        case dt
        case dtTxt = "dt_txt"
        case main
        case weather
        case clouds
        case wind
        case rain
        case snow
    }
}

struct Temperature: Codable {
    let day: Double?
    let min: Double?
    let max: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?
}

struct Coord: Codable {
    let lon: Double?
    let lat: Double?
}

struct WeatherInfo: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct MainInfo: Codable {
    let temp: Double?
    let pressure: Double?
    let humidity: Int?
    let tempMin: Double?
    let tempMax: Double?
    let seaLevel: Double?
    let grndLevel: Double?
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

struct Wind: Codable {
    let speed: Double?
    let deg: Double?
}

struct Clouds: Codable {
    let all: Int?
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
//    let message: String?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

struct Rain: Codable {
    let oneHour: Double?
    let threeHours: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

struct Snow: Codable {
    let oneHour: Double?
    let threeHours: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

