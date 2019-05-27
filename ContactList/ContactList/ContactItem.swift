//
//  ContactItem.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/16/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation
import UIKit

@objcMembers class Person: NSObject {
    
    private (set) var id: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var birthday: Date?
    var height: Int
    var notes: String
    var driverLicense: String
    
    var fullName: String {
        return firstName + (firstName.isEmpty ? "" : " ") + lastName
    }
    
    lazy var image: UIImage? = DataManager.getImage(fileName: id)
    
    
    init(firstName: String = "", lastName: String = "", phoneNumber: String = "", email: String = "", birthday: Date? = nil, height: Int = 0, notes: String = "", driverLicense: String = ""){
        self.id  = UUID.init().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.birthday = birthday
        self.height = height
        self.notes = notes
        self.driverLicense = driverLicense
    }
    
    required convenience init (coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let birthday = aDecoder.decodeObject(forKey: "birthday") as! Date?
        let height = aDecoder.decodeInteger(forKey: "height")
        let notes = aDecoder.decodeObject(forKey: "notes") as! String
        let driverLicense = aDecoder.decodeObject(forKey: "driverLicense") as! String
        
        self.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, birthday: birthday, height: height, notes: notes, driverLicense: driverLicense)
        self.id = id
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email && lhs.birthday == rhs.birthday && lhs.height == rhs.height && lhs.notes == rhs.notes && lhs.driverLicense == rhs.driverLicense
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object is Person {
            let person = object as! Person
            return self.firstName == person.firstName && self.lastName == person.lastName && self.phoneNumber == person.phoneNumber && self.email == person.email && self.birthday == person.birthday && self.height == person.height && self.notes == person.notes && self.driverLicense == person.driverLicense
        }
        return false
    }
}

extension Person: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let newPerson = Person(firstName: self.firstName, lastName: self.lastName, phoneNumber: self.phoneNumber, email: self.email, birthday: self.birthday, height: self.height, notes: self.notes, driverLicense: self.driverLicense)
        newPerson.id = self.id
        return newPerson
    }
}

extension Person: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(driverLicense, forKey: "driverLicense")
    }
}

struct PersonViewModel {
    let image: UIImage
    let lineFirst: String
    let lineSecond: String
    
    init(with contact: Person) {
        image = contact.image ?? Constants.emptyAvatar
        lineFirst = contact.firstName + (contact.firstName.isEmpty ? "" : " ") + contact.lastName
        lineSecond = !contact.phoneNumber.isEmpty ? contact.phoneNumber : contact.email
    }
}
