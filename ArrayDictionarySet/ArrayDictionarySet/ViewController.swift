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
        
        print("MyDictionary:")
        
        let dict = MyDictionary<Int, String>()
        dict.add(key: 100, value: "100")
        dict.add(key: 50, value: "50")
        dict.add(key: 75, value: "75")
        dict.add(key: 150, value: "150")
        print(dict)

        do {
            let res = try dict.getValue(key: 150)
            print(res)
        }
        catch {print("Error")}

        do {
            let res2 = try dict.getValue(key: 500)
            print(res2)
        }
        catch {print("Error")}

        do {try dict.remove(key: 75)}
        catch {print("Error")}
        print(dict)
        

        print("\nMySet:")
        
        let set = MySet<Int>()
        set.add(value: 100)
        set.add(value: 50)
        set.add(value: 75)
        set.add(value: 150)
        print(set)
        
        do {
            let res = try set.getValue(value: 150)
            print(res)
        }
        catch {print("Error")}
        
        do {
            let res2 = try set.getValue(value: 500)
            print(res2)
        }
        catch {print("Error")}
        
        print(set.valueExists(value: 75))
        
        do {try set.remove(value: 75)}
        catch {print("Error")}
        print(set)
        
        print(set.valueExists(value: 75))
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
    var parent:DictionaryNode?
    var leftNode:DictionaryNode?
    var rightNode:DictionaryNode?
    
    init(key:K, value:V, parent:DictionaryNode? = nil){
        self.key = key
        self.value = value
        self.parent = parent
    }
}

enum MyDictionaryErrors: Error{
    case itemIsNotExist
}

class MyDictionary<K:Comparable,V>: CustomStringConvertible{
    
    private var head:DictionaryNode<K,V>?
    
    //add
    //
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
                node.leftNode = DictionaryNode(key: key, value: value, parent: node)
                return
            }
            addToBranch(node:leftNodeCurrentBranch, key:key, value:value)
        }
            
        else{
            guard let rightNodeCurrentBranch = node.rightNode else{
                node.rightNode = DictionaryNode(key: key, value: value, parent: node)
                return
            }
            addToBranch(node:rightNodeCurrentBranch, key:key, value:value)
        }
    }
    
    //get
    //
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
    
    //remove
    //
    func remove(key:K) throws{
        guard let headNode = head else{
            throw MyDictionaryErrors.itemIsNotExist
        }
        
        try findItemToRemove(node: headNode, key: key)
    }
    
    func findItemToRemove(node:DictionaryNode<K,V>, key:K) throws{
        if node.key == key{
            let exchangeItem = removeItemandReturnItemForExchange(node: node)
            
            if node.key == node.parent?.leftNode?.key{
                node.parent?.leftNode = exchangeItem
            } else if node.key == node.parent?.rightNode?.key{
                node.parent?.rightNode = exchangeItem
            }
            
            node.parent = nil
            node.leftNode = nil
            node.rightNode = nil
            
        } else if node.key > key{
            guard let leftNode = node.leftNode else{
                throw MyDictionaryErrors.itemIsNotExist
            }
            try findItemToRemove(node:leftNode, key:key)
            
        } else {
            guard let rightNode = node.rightNode else{
                throw MyDictionaryErrors.itemIsNotExist
            }
            try findItemToRemove(node:rightNode, key:key)
        }
    }
    
    func removeItemandReturnItemForExchange(node:DictionaryNode<K,V>) -> DictionaryNode<K,V>?{
        if node.leftNode == nil && node.rightNode == nil{
            return nil
        } else if node.leftNode != nil && node.rightNode == nil{
            return node.leftNode
        } else if node.rightNode != nil && node.rightNode?.leftNode == nil{
            node.rightNode?.leftNode = node.leftNode
            return node.rightNode
        } else{
            var currentLeftChild = node.rightNode?.leftNode
            var fatherOfLeftChild = node.rightNode
            while currentLeftChild?.leftNode != nil{
                fatherOfLeftChild = currentLeftChild
                currentLeftChild = currentLeftChild?.leftNode
            }
            if currentLeftChild?.rightNode != nil{
                fatherOfLeftChild?.leftNode = currentLeftChild?.rightNode
            }
            return currentLeftChild
        }
    }
    
    //description
    //
    var description: String{
        guard let headNode = head else{
            return "isEmpty"
        }
        return getDescription(node:headNode)
    }
    
    func getDescription(node:DictionaryNode<K,V>) -> String{
        if let nodeLeftValue = node.leftNode{
            var globalValueString = getDescription(node: nodeLeftValue) + "\(node.value) "
            if let nodeRightValue = node.rightNode{
                globalValueString += getDescription(node: nodeRightValue)
            }
            return globalValueString
            
        } else {
            var rightValueString = ""
            if let nodeRightValue = node.rightNode{
                rightValueString = getDescription(node: nodeRightValue)
            }
            return "\(node.value) " + rightValueString
        }
    }
}


class SetNode<V>{
    var value:V
    var parent:SetNode?
    var leftNode:SetNode?
    var rightNode:SetNode?
    
    init(value:V, parent:SetNode? = nil){
        self.value = value
        self.parent = parent
    }
}

class MySet<V:Comparable>: CustomStringConvertible{
    
    private var head:SetNode<V>?
    
    //add
    //
    func add(value:V){
        guard let headNode = head else{
            head = SetNode(value: value)
            return
        }
        
        addToBranch(node:headNode, value:value)
    }
    
    func addToBranch(node:SetNode<V>, value:V){
        if node.value == value {
            return
            
        } else if node.value > value{
            guard let leftNodeCurrentBranch = node.leftNode else{
                node.leftNode = SetNode(value: value, parent: node)
                return
            }
            addToBranch(node:leftNodeCurrentBranch, value:value)
        }
            
        else{
            guard let rightNodeCurrentBranch = node.rightNode else{
                node.rightNode = SetNode(value: value, parent: node)
                return
            }
            addToBranch(node:rightNodeCurrentBranch, value:value)
        }
    }
    
    //get
    //
    func getValue(value:V) throws -> V{
        guard let headNode = head else{
            throw MyDictionaryErrors.itemIsNotExist
        }
        
        return try getBranchValue(node: headNode, value: value)
    }
    
    func getBranchValue(node:SetNode<V>, value:V) throws -> V{
        if node.value == value {
            return node.value
            
        } else if node.value > value{
            guard let leftNode = node.leftNode else{
                throw MyDictionaryErrors.itemIsNotExist
            }
            return try getBranchValue(node: leftNode, value: value)
            
        } else {
            guard let rightNode = node.rightNode else{
                throw MyDictionaryErrors.itemIsNotExist
            }
            return try getBranchValue(node: rightNode, value: value)
        }
    }
    
    //remove
    //
    func remove(value:V) throws{
        guard let headNode = head else{
            throw MyDictionaryErrors.itemIsNotExist
        }
        
        try findItemToRemove(node: headNode, value: value)
    }
    
    func findItemToRemove(node:SetNode<V>, value:V) throws{
        if node.value == value{
            let exchangeItem = removeItemandReturnItemForExchange(node: node)
            
            if node.value == node.parent?.leftNode?.value{
                node.parent?.leftNode = exchangeItem
            } else if node.value == node.parent?.rightNode?.value{
                node.parent?.rightNode = exchangeItem
            }
            
            node.parent = nil
            node.leftNode = nil
            node.rightNode = nil
            
        } else if node.value > value{
            guard let leftNode = node.leftNode else{
                throw MyDictionaryErrors.itemIsNotExist
            }
            try findItemToRemove(node:leftNode, value: value)
            
        } else {
            guard let rightNode = node.rightNode else{
                throw MyDictionaryErrors.itemIsNotExist
            }
            try findItemToRemove(node:rightNode, value: value)
        }
    }
    
    func removeItemandReturnItemForExchange(node:SetNode<V>) -> SetNode<V>?{
        if node.leftNode == nil && node.rightNode == nil{
            return nil
        } else if node.leftNode != nil && node.rightNode == nil{
            return node.leftNode
        } else if node.rightNode != nil && node.rightNode?.leftNode == nil{
            node.rightNode?.leftNode = node.leftNode
            return node.rightNode
        } else{
            var currentLeftChild = node.rightNode?.leftNode
            var fatherOfLeftChild = node.rightNode
            while currentLeftChild?.leftNode != nil{
                fatherOfLeftChild = currentLeftChild
                currentLeftChild = currentLeftChild?.leftNode
            }
            if currentLeftChild?.rightNode != nil{
                fatherOfLeftChild?.leftNode = currentLeftChild?.rightNode
            }
            return currentLeftChild
        }
    }
    
    //value exists
    //
    func valueExists(value:V) -> Bool{
        guard let headNode = head else{
            return false
        }
        
        do {
            let _ = try getBranchValue(node: headNode, value: value)
        } catch {
            return false
        }
        
        return true
    }
    
    //description
    //
    var description: String{
        guard let headNode = head else{
            return "isEmpty"
        }
        return getDescription(node:headNode)
    }
    
    func getDescription(node:SetNode<V>) -> String{
        if let nodeLeftValue = node.leftNode{
            var globalValueString = getDescription(node: nodeLeftValue) + "\(node.value) "
            if let nodeRightValue = node.rightNode{
                globalValueString += getDescription(node: nodeRightValue)
            }
            return globalValueString
            
        } else {
            var rightValueString = ""
            if let nodeRightValue = node.rightNode{
                rightValueString = getDescription(node: nodeRightValue)
            }
            return "\(node.value) " + rightValueString
        }
    }
}





