//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Maksym Humeniuk on 5/30/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var cityName: UILabel!
    @IBOutlet private weak var temperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherAPIManager.myRequest(.current(searchLocationType: .byCityName(q: "Vinnytsya,ua"))) { [weak self] (data) in
            let currentData = data as! CurrentWeatherData
            self?.cityName.text = currentData.name
            if let currentTemperature = currentData.main?.temp {
                self?.temperature.text = "\(currentTemperature)\u{00B0}C"
            }
            
        }
        
//        WeatherAPIManager.myRequest(.fiveDay(searchLocationType: .byCityName(q: "Vinnytsya,ua"))) { (data) in
//            print(data)
//        }
    }
}


