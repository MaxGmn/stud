//
//  ViewController.swift
//  ArrayDictionarySet
//
//  Created by Maksym Humeniuk on 4/19/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstTask();
    }
}

func firstTask(){
    
    let monday: Set = ["stud01", "stud02", "stud05", "stud06", "stud07"]
    let tuesday: Set = ["stud03", "stud06", "stud08", "stud10"]
    let wednesday: Set = ["stud01", "stud03", "stud07", "stud09", "stud10"]
    
    print("Students, who were all days: \(monday.intersection(tuesday).intersection(wednesday).sorted())\n")
    
    print("Students, who were just two days:\n" +
        "\t monday and tueday: \(monday.intersection(tuesday).sorted())\n" +
        "\t tuesday and wednesday: \(tuesday.intersection(wednesday).sorted())\n" +
        "\t monday and wednesday: \(monday.intersection(wednesday).sorted())\n")
    
    print("Students, who were in monday and wednestay, but not tuesday: \(monday.intersection(wednesday).subtracting(tuesday).sorted())")
}




