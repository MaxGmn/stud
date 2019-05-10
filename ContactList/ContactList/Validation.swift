//
//  Validation.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/10/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation



func isValidEmail(email: String) -> Bool {
    
    if email.isEmpty {return true}

    let emailRegEx = "[\\w-]+@([\\w-]+\\.)+[\\w-]+"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    let result = emailTest.evaluate(with: email)
    
    return result
}

func isValidPhoneNumber(number: String) -> Bool {
    
    let phoneRegEx = "^\\+?\\d*"
    
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
    
    let result = phoneTest.evaluate(with: number)
    
    return result
}

func isValidName(text: String) -> Bool {
    
    if text.isEmpty {return true}
    
    let textRegEx = ".*\\w+.*"
    
    let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
    
    let result = textTest.evaluate(with: text)
    
    return result && text.count <= 20
}
