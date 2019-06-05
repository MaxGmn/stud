//
//  Weather.swift
//  WeatherApplication
//
//  Created by Maksym Humeniuk on 6/4/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

// main structures
struct CurrentWeatherData: Codable {
    let id: Int?
    let name: String?
    let cod: Int?
    let base :String?
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
    
}
struct DailyWeatherData: Codable {
    let cod: Int?
    let message: Double?
    let cnt: Int?
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
    let pressure: Double?
    let humidity: Int?
    let speed: Double?
    let deg: Int?
    let clouds: Int?
    let rain: Int?
    let snow: Int?
    let temp: Temperature?
    let weather: [WeatherInfo]?
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
    let pressure: Int?
    let humidity: Int?
    let tempMin: Double?
    let tempMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Wind: Codable {
    let speed: Int?
    let deg: Int?
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

