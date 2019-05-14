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
    static let emptyAvatar = UIImage(named: "emptyAvatar")!
    static let validColor = UIColor.white
    static let invalidColor = UIColor.red
}

extension Bool {
    var color: UIColor {
        return self ? Constants.validColor : Constants.invalidColor
    }
}

class Person: NSObject {
   
    private (set) var id: String
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var email: String?
    
    var image: UIImage? {
        get {return UserDefaultsWorking.getImage(fileName: id)}
    }
    
    init(firstName: String? = "", lastName: String? = "", phoneNumber: String? = "", email: String? = ""){
        self.id  = UUID.init().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
    }
    
    required convenience init (coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        
        self.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        self.id = id
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email
    }
}

extension Person: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let newPerson = Person(firstName: self.firstName, lastName: self.lastName, phoneNumber: self.phoneNumber, email: self.email)
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
    }
}

struct PersonViewModel {
    let image: UIImage
    let lineFirst: String
    let lineSecond: String
    
    init(with contact: Person) {
        image = UserDefaultsWorking.getImage(fileName: contact.id)
        lineFirst = contact.firstName! + (contact.firstName!.isEmpty ? "" : " ") + contact.lastName!
        lineSecond = !contact.phoneNumber!.isEmpty ? contact.phoneNumber! : contact.email!
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
