//
//  ViewController.swift
//  ArraySort
//
//  Created by Maksym Humeniuk on 4/23/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let testArray = [9, 8, 7, 6, 5, 4, 3, 2, 1]
        
        print(bubbleSort(inputArray: testArray))
    }


    func bubbleSort(inputArray:[Int]) -> [Int]{
        var sortedArray = inputArray
        if sortedArray.count > 1{
            
            for _ in 0..<sortedArray.count - 1{
                for j in 1..<sortedArray.count{
                    if sortedArray[j] < sortedArray[j-1]{
                        let temp = sortedArray[j]
                        sortedArray[j] = sortedArray[j-1]
                        sortedArray[j-1] = temp
                    }
                }
            }
        }
        return sortedArray;
    }
    
    func inputSort(inputArray:[Int]) -> [Int] {
        <#function body#>
    }
}

