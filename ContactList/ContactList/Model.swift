//
//  Model.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

var personsArray = [Person]()


class Person {
    var firstName: String
    var lastName: String
    var phoneNumber : String
    var email: String
    var imagePath: String?
    
    init(firstName: String = "", lastName: String = "", phoneNumber : String = "", email: String = "", imagePath: String? = nil){
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.imagePath = imagePath
    }
}



