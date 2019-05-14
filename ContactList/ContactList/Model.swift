//
//  Model.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let emptyAvatar = UIImage(named: "emptyAvatar")
    static let validColor = UIColor.white
    static let invalidColor = UIColor.red
}

extension Bool {
    var color: UIColor {
        return self ? Constants.validColor : Constants.invalidColor
    }
}


class Person {
   
    private (set) var id: String
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var email: String?
    var image: UIImage?
    
    init(firstName: String? = "", lastName: String? = "", phoneNumber: String? = "", email: String? = "", image: UIImage? = nil){
        self.id  = UUID.init().uuidString
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
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email
    }
}

class CellFieldsBuilder {
    
    static func getImage(image: UIImage?) -> UIImage {
        return image ?? Constants.emptyAvatar!
    }
    
    static func getName(firstName: String, lastName: String) -> String {
        return firstName + (firstName.isEmpty ? "" : " ") + lastName
    }
    
    static func getContact (phoneNumber: String, email: String) -> String {
        return !phoneNumber.isEmpty ? phoneNumber : email
    }
}

protocol ContactListDelegate {
    func updatePersonInformation(person: Person)
    func deletePerson(by id: String)
}

enum ImageEditState: Equatable {
    case noChanges
    case removed
    case changed(newImage: UIImage)
}
