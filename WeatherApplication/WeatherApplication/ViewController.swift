//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Maksym Humeniuk on 5/30/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherAPIManager.myRequest(.current(searchLocationType: .byCityName(q: "Vinnytsya,ua"))) { (data) in
            print(data)
        }
        
        WeatherAPIManager.myRequest(.fiveDay(searchLocationType: .byCityName(q: "Vinnytsya,ua"))) { (data) in
            print(data)
        }
    }
}


