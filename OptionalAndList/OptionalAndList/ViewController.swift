//
//  ViewController.swift
//  OptionalAndList
//
//  Created by Maksym Humeniuk on 4/17/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let a = MyOptional(10).unwrap();
//        print(a);
//        let b = MyOptional<Any>().unwrap();
//        print(b);
        // Do any additional setup after loading the view.
        
//        let linkedList = LinkedList(value: 1)
//        linkedList.addFirst(value: 0)
//        linkedList.addLast(value: 2)
//        print(linkedList)
//
//        linkedList.delFirst()
//        print(linkedList)
//
//        linkedList.delFirst()
//        print(linkedList)
//
//        linkedList.delFirst()
//        print(linkedList)
        
//        linkedList.delLast()
//        print(linkedList)
//
//        linkedList.delLast()
//        print(linkedList)
//
//        linkedList.delLast()
//        print(linkedList)
        
        print("Queue")
        
        let queue = Queue(value: 1)
        queue.queue(value: 3)
        queue.queue(value: 5)
        queue.queue(value: 7)
        queue.queue(value: 10)
        print(queue.toString())
        
        if let a = queue.dequeue() {
            print (a)
        }
        print(queue.toString())
        
        if let a = queue.dequeue() {
            print (a)
        }
        print(queue.toString())
        
        if let a = queue.dequeue() {
            print (a)
        }
        print(queue.toString())
        
        
        print("Stack")
        
        let stack = Stack(value: 1)
        stack.push(value: 3)
        stack.push(value: 5)
        stack.push(value: 7)
        stack.push(value: 10)
        print(stack.toString())
        
        if let a = stack.pop() {
            print (a)
        }
        print(stack.toString())
        
        if let a = stack.pop() {
            print (a)
        }
        print(stack.toString())
        
        if let a = stack.pop() {
            print (a)
        }
        print(stack.toString())
    }


}

enum MyOptional<T>{
    case some(T)
    case none
    
    init(_ value: T){
        self = .some(value)
    }
    
    init(){
        self = .none
    }
    
    func unwrap() -> Any{
        switch self {
        case .some(let x):
            return x
        default:
            break
        }
        return MyOptional.none
    }
}

//func add(_ first: MyOptional<Int>, _ second: MyOptional<Int>) -> MyOptional<Int>{
//    let a = first.unwrap()
//    let b = second.unwrap()
//    return MyOptional(a + b)
//}

class Node<T>{
    var value: T
    var prev: Node?
    var next: Node?
    
    init(value: T, prev: Node? = nil, next: Node? = nil){
        self.value = value
        self.prev = prev
        self.next = next
    }
}


class LinkedList<T>: CustomStringConvertible{
    
    var first: Node<T>?
    var last: Node<T>?
    
//    init(){}
    
    init(value: T){
        let firstNode = Node(value: value);
        first = firstNode
        last = firstNode
    }
    
    func addFirst(value: T){
        let newFirstNode = Node(value: value, next: first)
        first = newFirstNode
        if let oldFirst = newFirstNode.next {
            oldFirst.prev = first
        }
    }
    
    func addLast(value: T){
        let newLastNode = Node(value: value, prev: last)
        last = newLastNode
        if let oldLast = newLastNode.prev{
            oldLast.next = last
        }
    }
    
    func delFirst(){
        if first === last {
            first = nil
            last = nil
        } else if let delFirstNode = first{
        let firstNode = delFirstNode.next
        delFirstNode.next = nil
        firstNode?.prev = nil
        
        if firstNode != nil{
            first = firstNode!
            }
        }
    }
    
    func delLast(){
        if first === last {
            first = nil
            last = nil
        } else if let delLastNode = last{
        let lastNode = delLastNode.prev
        delLastNode.prev = nil
        lastNode?.next = nil
        
        if lastNode != nil{
            last = lastNode!
            }
        }
    }
    
    func returnFirst() -> T?{
        if let item = first{
            return item.value
        }
        return nil
    }
    
    func returnLast() -> T?{
        if let item = last{
            return item.value
        }
        return nil
    }
    
    var description: String{
        var result = "["
        var item: Node? = first
        while let i = item{
            result += "\(i.value)"
            item = item?.next
            if item != nil {
                result += ", "
            }
        }
        result += "]"
        return result
    }
    

}

class Queue<T>{
    let linkedList: LinkedList<T>
    var isEmpty = true
    
    init(value: T){
        linkedList = LinkedList(value: value)
        isEmpty = false
    }
    
    func queue(value: T){
        linkedList.addLast(value: value)
    }
    
    func dequeue() -> T? {
        if let result = linkedList.returnFirst(){
            linkedList.delFirst()
            if linkedList.first == nil {
                isEmpty = true
            }
            return result
        }
        return nil
    }
    
    func toString() -> String{
        return linkedList.description
    }
}


class Stack<T>{
    let linkedList: LinkedList<T>
    var isEmpty = true
    
    init(value: T){
        linkedList = LinkedList(value: value)
        isEmpty = false
    }
    
    func push(value: T){
        linkedList.addLast(value: value)
    }
    
    func pop() -> T? {
        if let result = linkedList.returnLast(){
            linkedList.delLast()
            if linkedList.last == nil {
                isEmpty = true
            }
            return result
        }
        return nil
    }
    
    func toString() -> String{
        return linkedList.description
    }
}
