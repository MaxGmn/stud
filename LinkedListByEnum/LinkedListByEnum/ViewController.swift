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

    case empty
    case node(value: T, next: LinkedList)
    
    init(){self = .empty}

    mutating func append(value: T){
        self = addValueToLastLevel(value: value, list: self)
    }
    
    func addValueToLastLevel(value: T, list: LinkedList) -> LinkedList{
        
        switch list{
        case .empty:
            return .node(value: value, next: .empty)
        case let .node(currentValue, nextList):
            let previousLinkedListItem = addValueToLastLevel(value: value, list: nextList)
            return .node(value: currentValue, next: previousLinkedListItem)
        }
    }
    
    func getItem(item: Int) throws -> T{
        let value = try getValueByIndex(list: self, item: item)
        return value
    }
    
    func getValueByIndex(list: LinkedList, item: Int, currentItem: Int = 0) throws -> T{
        
        switch list{
        case let .node(value, nextlist):
            if item == currentItem{
                return value
            }
            return try getValueByIndex(list: nextlist, item: item, currentItem: currentItem + 1)
        case .empty:
            throw ListErrors.indexOutOfRange
        }
        
    }
    
    var description: String {
        return createListDescription(list: self, description: "[")
    }
    
   func createListDescription(list: LinkedList, description: String) -> String{
        
        switch list{
        case let .node(value, nextlist):
            return createListDescription(list: nextlist, description: description + "\(value) ")
        case .empty:
            return description + "]"
        }
        
    }
}


enum ListErrors : Error{
    case indexOutOfRange
}
