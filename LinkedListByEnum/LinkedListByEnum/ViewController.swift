//
//  ViewController.swift
//  LinkedListByEnum
//
//  Created by Maksym Humeniuk on 4/18/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var linkedList = LinkedList<Int>()
        linkedList.append(value: 10)
        linkedList.append(value: 20)
        linkedList.append(value: 30)
        linkedList.append(value: 40)
        linkedList.append(value: 50)
        
        print(linkedList);
        
        do{
            let i = try linkedList.getItem(item: 0)
            print(i)
        } catch {
            print("Something wrong")
        }

    }
    
    
}


indirect enum LinkedList <T> : CustomStringConvertible{

    case Empty
    case Node(value: T, next: LinkedList)
    
    init(){self = .Empty}

    mutating func append(value: T){
        self = addValueToLastLevel(value: value, list: self)
    }
    
    func addValueToLastLevel(value: T, list: LinkedList) -> LinkedList{
        
        switch list{
        case .Empty:
            return .Node(value: value, next: .Empty)
        case let .Node(currentValue, nextList):
            let previousLinkedListItem = addValueToLastLevel(value: value, list: nextList)
            return .Node(value: currentValue, next: previousLinkedListItem)
        }
    }
    
    func getItem(item: Int) throws -> T{
        let value = try getValueByIndex(list: self, item: item)
        return value
    }
    
    func getValueByIndex(list: LinkedList, item: Int, currentItem: Int = 0) throws -> T{
        
        switch list{
        case let .Node(value, nextlist):
            if item == currentItem{
                return value
            }
            return try getValueByIndex(list: nextlist, item: item, currentItem: currentItem + 1)
        case .Empty:
            throw ListErrors.IndexOutOfRange
        }
        
    }
    
    var description: String {
        return createListDescription(list: self, description: "[")
    }
    
   func createListDescription(list: LinkedList, description: String) -> String{
        
        switch list{
        case let .Node(value, nextlist):
            return createListDescription(list: nextlist, description: description + "\(value) ")
        case .Empty:
            return description + "]"
        }
        
    }
}


enum ListErrors : Error{
    case IndexOutOfRange
}
