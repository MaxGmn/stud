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
    var remove: String
}

let array = DataStructureItem(title: "Array",
                                   description: "An array is a data structure consisting of a collection of elements (values or variables), each identified by at least one array index or key. An array is stored such that the position of each element can be computed from its index tuple by a mathematical formula. The simplest type of data structure is a linear array, also called one-dimensional array.",
                                   add: "O(n)",
                                   read: "O(n)",
                                   remove: "O(n)")


let linkedList = DataStructureItem(title: "Linked List",
                                   description: "A linked list is a linear data structure where each element is a separate object.\nEach element (we will call it a node) of a list is comprising of two items - the data and a reference to the next node. The last node has a reference to null. The entry point into a linked list is called the head of the list. It should be noted that head is not a separate node, but the reference to the first node. If the list is empty then the head is a null reference.\nA linked list is a dynamic data structure. The number of nodes in a list is not fixed and can grow and shrink on demand.",
                                   add: "O(n)",
                                   read: "O(1)",
                                   remove: "O(1)")

let stack = DataStructureItem(title: "Stack",
                              description: "The Stack is a simple data structure which allows you to create a linear “stack” of items (hence the name). It is a LIFO ( “Last In, First Out”) data structure meaning that the last item added to the stack is the first one that can be removed.\nIt has some very practical use cases and if you’ve done anything on a computer today, you’ve interacted with a Stack. You’ll learn where a Stack is currently used and how it can be helpful.",
                              add: "O(n)",
                              read: "O(1)",
                              remove: "O(1)")

let queue = DataStructureItem(title: "Queue",
                              description: "A queue is a collection in which the entities in the collection are kept in order and the principal (or only) operations on the collection are the addition of entities to the rear terminal position, known as enqueue, and removal of entities from the front terminal position, known as dequeue. This makes the queue a First-In-First-Out (FIFO) data structure. In a FIFO data structure, the first element added to the queue will be the first one to be removed. This is equivalent to the requirement that once a new element is added, all elements that were added before have to be removed before the new element can be removed.",
                              add: "O(n)",
                              read: "O(1)",
                              remove: "O(1)")

let set = DataStructureItem(title: "Set",
                              description: "A set is an abstract data type that can store unique values, without any particular order. It is a computer implementation of the mathematical concept of a finite set. Unlike most other collection types, rather than retrieving a specific element from a set, one typically tests a value for membership in a set.",
                              add: "?",
                              read: "?",
                              remove: "?")

let dictionary = DataStructureItem(title: "Dictionary",
                              description: "A dictionary is a type of hash table, providing fast access to the entries it contains. Each entry in the table is identified using its key, which is a hashable type such as a string or number. You use that key to retrieve the corresponding value, which can be any object. In other languages, similar data types are known as hashes or associated arrays.",
                              add: "?",
                              read: "?",
                              remove: "?")

let hashTable = DataStructureItem(title: "Hash Table",
                                  description: "A hash table (hash map) is a data structure that implements an associative array abstract data type, a structure that can map keys to values. A hash table uses a hash function to compute an index into an array of buckets or slots, from which the desired value can be found.\nIdeally, the hash function will assign each key to a unique bucket, but most hash table designs employ an imperfect hash function, which might cause hash collisions where the hash function generates the same index for more than one key. Such collisions must be accommodated in some way.",
                              add: "O(1)",
                              read: "O(1)",
                              remove: "O(1)")

let dataStructures: [DataStructureItem] = [array, linkedList, stack, queue, set, dictionary, hashTable]
