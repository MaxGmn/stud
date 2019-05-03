//
//  Model.swift
//  ArraySortDemonstration
//
//  Created by Maksym Humeniuk on 5/2/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

func bubbleSort(inputArray:[Int]) -> (from: Int, to: Int, sortedArray: [Int]){
    var sortedArray = inputArray
    
    if sortedArray.count > 1{
        for _ in 0..<sortedArray.count - 1{
            for j in 1..<sortedArray.count{
                if sortedArray[j] < sortedArray[j-1]{
                    let temp = sortedArray[j]
                    sortedArray[j] = sortedArray[j-1]
                    sortedArray[j-1] = temp
                    return (j, j-1, sortedArray)
                }
            }
        }
    }
    return (0, 0, sortedArray)
}

func inputSort(inputArray:[Int]) -> (from: Int, to: Int, sortedArray: [Int]){
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
            if key != sortedArray[i]{
                return (i, j+1, sortedArray)
            }
        }
    }
    return (0, 0, sortedArray)
}

func arrayFilling() -> [Int]{
    var newArray = [Int]()
    
    for _ in 0...9 {
        newArray.append(Int.random(in: -100...100))
    }
    return newArray
}
