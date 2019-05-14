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

class Person: NSObject, NSCoding {
    
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(email, forKey: "email")
    }
    
    required convenience init (coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        self.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
    }
    
    
//    func copy() -> Person{
//        return Person(firstName: self.firstName, lastName: self.lastName, phoneNumber: self.phoneNumber, email: self.email, image: self.image)
//    }
//
//    static func == (lhs: Person, rhs: Person) -> Bool {
//        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email && lhs.image.isEqual(rhs.image)
//    }
}

protocol ContactListHandler {
    func addNewPerson(person: Person)
    func updatePresonInformation(person: Person, at index: Int)
    func deletePerson(at index: Int)
}

//func putArrayIntoUserDefaults(array: [Person]) {
//    let userDefaults = UserDefaults.standard
//    do{
//        let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
//        userDefaults.set(data, forKey: "persons")
//        userDefaults.synchronize()
//    } catch {
//        print("Something wrong")
//    }
//}
//
//func getArrayFromUserDefaults() -> [Person] {
//    if let data = UserDefaults.standard.object(forKey: "persons") {
//        return NSKeyedUnarchiver.unarchivedObject(ofClasses: [Person as AnyClass], from: data as! Data) as! [Person]
//    }
//    
//    return []
//}
