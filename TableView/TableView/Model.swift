//
//  Model.swift
//  TableView
//
//  Created by Maksym Humeniuk on 4/30/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

struct DataStructureItem {
    var title: String
    var description: String
    var add: String
    var read: String
    var remowe: String
}

let array = DataStructureItem(title: "Array",
                                   description: "",
                                   add: "",
                                   read: "",
                                   remowe: "")


let linkedList = DataStructureItem(title: "Linked List",
                                   description: "A linked list is a linear data structure where each element is a separate object.\nEach element (we will call it a node) of a list is comprising of two items - the data and a reference to the next node. The last node has a reference to null. The entry point into a linked list is called the head of the list. It should be noted that head is not a separate node, but the reference to the first node. If the list is empty then the head is a null reference.\nA linked list is a dynamic data structure. The number of nodes in a list is not fixed and can grow and shrink on demand.",
                                   add: "",
                                   read: "",
                                   remowe: "")

let stack = DataStructureItem(title: "Stack",
                              description: "",
                              add: "",
                              read: "",
                              remowe: "")

let queue = DataStructureItem(title: "Queue",
                              description: "",
                              add: "",
                              read: "",
                              remowe: "")

let set = DataStructureItem(title: "Set",
                              description: "",
                              add: "",
                              read: "",
                              remowe: "")

let dictionary = DataStructureItem(title: "Dictionary",
                              description: "",
                              add: "",
                              read: "",
                              remowe: "")

let hashTable = DataStructureItem(title: "Hash Table",
                              description: "",
                              add: "",
                              read: "",
                              remowe: "")

let dataStructures: [DataStructureItem] = [array, linkedList, stack, queue, set, dictionary, hashTable]
