//
//  ArrayCreator.swift
//  ArraySortInThreads
//
//  Created by Maksym Humeniuk on 5/30/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

class ArrayManager {
    
    static func getResultArraySorting(sortType: SortTypes, arrayType: BaseArrayType, _ numberOfIterations: Int) -> String {
        let baseArray = createArray(arrayType)
        
        let startDate = Date()
        for _ in 0...numberOfIterations-1 {
            sorting(array: baseArray, by: sortType)
        }
        let finishDate = Date()
        
        let timeInterval = finishDate.timeIntervalSince(startDate)
        let resultTime = timeInterval / Double(numberOfIterations)
        return arrayType.description + ": \(round(resultTime * 100000) / 100000)"
    }
}

private extension ArrayManager {
    
    static func sorting(array: [Int], by sortType: SortTypes) {
        switch sortType {
        case .bubble:
            _ = SortMetods.bubbleSort(inputArray: array)
        case .insertion:
            _ = SortMetods.insertionSort(inputArray: array)
        case .quick:
            _ = SortMetods.quickSort(inputArray: array)
        case .merge:
            _ = SortMetods.mergeSort(inputArray: array)
        }
    }
    
    static func createArray(_ arrayType: BaseArrayType) -> [Int]{
        switch arrayType {
        case .random(let itemsCount):
            return arrayFilling(itemsCount)
        case .sorted(let itemsCount):
            return arrayFilling(itemsCount).sorted()
        case .backSorted(let itemsCount):
            return arrayFilling(itemsCount).sorted(by: {$1 < $0})
        case .partiallySorted(let itemsCount):
            return SortMetods.shellSort(inputArray: arrayFilling(itemsCount), partiallySort: true)
        }
    }
    
    static func arrayFilling (_ itemsCount: Int) -> [Int] {
        var resultArray = [Int]()
        for _ in 0...itemsCount-1 {
            resultArray.append(Int.random(in: -10000...10000))
        }
        return resultArray
    }
}

enum BaseArrayType {
    case random(itemsCount: Int)
    case sorted(itemsCount: Int)
    case backSorted(itemsCount: Int)
    case partiallySorted(itemsCount: Int)
    
    var description: String {
        switch self {
        case .random(let count):
            return "Random, with \(count) items"
        case .sorted(let count):
            return "Sorted, with \(count) items"
        case .backSorted(let count):
            return "Back sorted, with \(count) items"
        case .partiallySorted(let count):
            return "Partially sorted, with \(count) items"
        }
    }
}
