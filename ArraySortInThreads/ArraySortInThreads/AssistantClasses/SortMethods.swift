//
//  SortMethods.swift
//  ArraySortInThreads
//
//  Created by Maksym Humeniuk on 5/30/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

class SortMetods {
    
    static func bubbleSort(inputArray:[Int]) -> [Int]{
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
    
    static func insertionSort(inputArray:[Int]) -> [Int] {
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
    
    static func quickSort(inputArray:[Int]) -> [Int] {
        
        var sortedArray = inputArray
        
        func internalSort (start:Int, end:Int){
            
            var i = start
            var j = end
            let middle = sortedArray[(i+j)/2]
            
            while i <= j {
                while sortedArray[i] < middle { i += 1 }
                while sortedArray[j] > middle { j -= 1 }
                
                if i <= j {
                    let temp = sortedArray[i]
                    sortedArray[i] = sortedArray[j]
                    sortedArray[j] = temp
                    i += 1
                    j -= 1
                }
            }
            
            if start < j {internalSort(start: start, end: j)}
            if i < end {internalSort(start: i, end: end)}
        }
        
        internalSort(start: 0, end: sortedArray.count - 1)
        return sortedArray
    }
    
    static func mergeSort(inputArray:[Int]) -> [Int] {
        
        func internalSort(start: Int, end: Int) -> [Int]{
            
            if start == end {return [inputArray[start]]}
            
            let middle = (start+end)/2
            
            let leftArray = internalSort(start: start, end: middle)
            let rightArray = internalSort(start: middle + 1, end: end)
            
            var i = 0
            var j = 0
            var resultArray = [Int]()
            
            while leftArray.count > i && rightArray.count > j{
                if leftArray[i] <= rightArray[j]{
                    resultArray.append(leftArray[i])
                    i += 1
                } else {
                    resultArray.append(rightArray[j])
                    j += 1
                }
            }
            
            if i < leftArray.count{
                resultArray += leftArray[i...leftArray.count - 1]
            }
            
            if j < rightArray.count{
                resultArray += rightArray[j...rightArray.count - 1]
            }
            
            return resultArray
        }
        
        return internalSort(start: 0, end: inputArray.count - 1)
    }
}

enum SortTypes: String {
    case bubble
    case insertion
    case quick
    case merge
}
