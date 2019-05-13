//
//  Model.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation
import UIKit

let emptyAvatar = UIImage(named: "emptyAvatar")!

class Person {
   
    private (set) var id: UUID
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var email: String?
    var image: UIImage?
    
    init(firstName: String? = "", lastName: String? = "", phoneNumber: String? = "", email: String? = "", image: UIImage? = nil){
        self.id  = UUID.init()
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.image = image
    }
}

extension Person: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let newPerson = Person(firstName: self.firstName, lastName: self.lastName, phoneNumber: self.phoneNumber, email: self.email, image: self.image)
        newPerson.id = self.id
        return newPerson
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email && lhs.image == rhs.image
    }
}

func findItemIndex(by id: UUID, in array: [Person]) -> Int? {
    for (key, value) in array.enumerated() {
        if value.id == id {
            return key
        }
    }
    return nil
}

protocol ContactListDelegate {
    func updatePresonInformation(person: Person)
    func deletePerson(by id: UUID)
}

enum ImageEditState {
    case noChanges
    case removed
    case changed(newImage: UIImage)
}
