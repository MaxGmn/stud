//
//  Validation.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/10/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

class Validation {
        
    static func isValidField(text: String, kindOfField: ValidationFunctions) -> Bool {
        if text.isEmpty {return true}
        
        let textRegEx = kindOfField.getRegExForField
        
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        
        let result = textTest.evaluate(with: text)
        
        return result && (kindOfField == .forTextField ? text.count <= 20 : true)
    }
}

enum ValidationFunctions: Equatable {
    case forTextField
    case forPhoneNumber
    case forEmail
    
    var getRegExForField: String {
        switch self {
        case .forTextField: return ".*\\w+.*"
        case .forPhoneNumber: return "^\\+?\\d*"
        case .forEmail: return "[\\w-]+@([\\w-]+\\.)+[\\w-]+"
        }
    }
}
