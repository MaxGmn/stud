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
        
        print(MyDictionary())
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
    
    print("Students, who were in monday and wednestay, but not tuesday: \(monday.intersection(wednesday).subtracting(tuesday).sorted())\n")
}


class DictionaryNode<K,V>{
    var key:K
    var value:V
    var leftNode:DictionaryNode?
    var rightNode:DictionaryNode?
    
    init(key:K, value:V){
        self.key = key
        self.value = value
    }
}

enum MyDictionaryErrors: Error{
    case itemIsNotExist
}

class MyDictionary<K:Comparable,V>: CustomStringConvertible{
    
    var head:DictionaryNode<K,V>?
    
    func add(key:K, value:V){
        guard let headNode = head else{
            head = DictionaryNode(key: key, value: value)
            return
        }
        
        addToBranch(node:headNode, key:key, value:value)
    }
    
    func addToBranch(node:DictionaryNode<K,V>, key:K, value:V){
        if node.key == key {
            node.value = value
            
        } else if node.key > key{
            guard let leftNodeCurrentBranch = node.leftNode else{
                node.leftNode = DictionaryNode(key: key, value: value)
                return
            }
            addToBranch(node:leftNodeCurrentBranch, key:key, value:value)
        }
            
        else{
            guard let rightNodeCurrentBranch = node.rightNode else{
                node.rightNode = DictionaryNode(key: key, value: value)
                return
            }
            addToBranch(node:rightNodeCurrentBranch, key:key, value:value)
        }
    }
    
    func getValue(key:K) throws -> V{
        guard let headNode = head else{
            throw MyDictionaryErrors.itemIsNotExist
        }
        
        return try getBranchValue(node: headNode, key: key)
    }
    
    func getBranchValue(node:DictionaryNode<K,V>, key:K) throws -> V{
        if node.key == key {
            return node.value
            
        } else if node.key > key{
            guard let leftNode = node.leftNode else{
                throw MyDictionaryErrors.itemIsNotExist
            }
            return try getBranchValue(node: leftNode, key: key)
            
        } else {
            guard let rightNode = node.rightNode else{
                throw MyDictionaryErrors.itemIsNotExist
            }
            return try getBranchValue(node: rightNode, key: key)
        }
    }
    
    func remove(key:K){
        
    }
    
    var description: String{
        return "MyDictionaryClass"
    }
}




