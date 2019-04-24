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
        let testArray2 = [5, 3, 7, 1, 8, 5, 4, 3, 2, 1]
        
//        print(bubbleSort(inputArray: testArray))
//        print(inputSort(inputArray: testArray2))
        
         print(quickSort(inputArray: testArray))
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
        var sortedArray = inputArray
        
        if sortedArray.count > 1{
            for i in 1..<sortedArray.count{
                let key = sortedArray[i]
                var j = i-1
                while j >= 0 && key < sortedArray[j]{
                    sortedArray[j+1] = sortedArray[j]
                    j -= 1
                }
                sortedArray[j+1] = key
            }
        }
        return sortedArray;
    }
    
    func quickSort(inputArray:[Int]) -> [Int] {
        
        var tempArray = inputArray
        
        var i = 0
        var j = tempArray.count - 1
        let p = tempArray[tempArray.count/2]
        
        while i < j {
            while tempArray[i] < p { i += 1 }
            while tempArray[j] > p { j -= 1 }
            
            if i < j {
                let temp = tempArray[i]
                tempArray[i] = tempArray[j]
                tempArray[j] = temp
                i += 1
                j -= 1
            }
        }
        
        var frontSide = [Int]()
        var backSide = [Int]()
        if j > 0 { frontSide = quickSort(inputArray: [Int](tempArray[0...j-1]))}
        if tempArray.count - 1 > i { backSide = quickSort(inputArray: [Int](tempArray[i+1...tempArray.count - 1]))}
        
        return frontSide + [p] + backSide
    }
    
    func mergeSort(inputArray:[Int]) -> [Int] {
        var sortedArray = inputArray
        
        if sortedArray.count > 1{

        }
        return sortedArray;
    }
}

