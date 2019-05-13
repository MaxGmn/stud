//
//  Model.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation
import UIKit

let emptyAvatar = UIImage(named: "emptyAvatar")

class Person: Equatable {
    
    
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var email: String?
    var image: UIImage
    
    init(firstName: String? = "", lastName: String? = "", phoneNumber: String? = "", email: String? = "", image: UIImage? = nil){
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.image = image ?? emptyAvatar!
    }
    
    func copy() -> Person{
        return Person(firstName: self.firstName, lastName: self.lastName, phoneNumber: self.phoneNumber, email: self.email, image: self.image)
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email && lhs.image.isEqual(rhs.image) 
    }
}

protocol ContactListHandler {
    func addNewPerson(person: Person)
    func updatePresonInformation(person: Person, at index: Int)
    func deletePerson(at index: Int)
}

