//
//  Model.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

//var personsArray = [Person]()

var personsArray = fillPersons()

class Person: Equatable {
    
    
    var firstName: String?
    var lastName: String?
    var phoneNumber : String?
    var email: String?
    var imagePath: String?
    
    init(firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, email: String? = nil, imagePath: String? = nil){
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.imagePath = imagePath
    }
    
    func copy() -> Person{
        return Person(firstName: self.firstName, lastName: self.lastName, phoneNumber: self.phoneNumber , email: self.email,imagePath: self.imagePath)
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {        
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email && lhs.imagePath == rhs.imagePath
    }
}

func fillPersons() -> [Person] {
    
    let firstPerson = Person(firstName: "James", lastName: "Bond", phoneNumber: "555-22-33", email: "jb@Gmail.com", imagePath: "emptyAvatar")
    let secondPerson = Person(firstName: "Billy", email: "bill@Gmail.com", imagePath: "emptyAvatar")
    let thirdPerson = Person(phoneNumber: "911", email: "hz@Gmail.com", imagePath: "emptyAvatar")
    
    return [firstPerson, secondPerson, thirdPerson]    
}


protocol Delegate {
    func onRowAddition(newIndex: Int)
}
