//
//  Search.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/16/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation

class Search {
    
    static func getFilterResults(from array: [Person], by searchText: String) -> ([Person], [NSAttributedString]) {
        var resultStringsArray = [NSAttributedString]()
        
        let filteredPersons = array.filter({ (person) -> Bool in
            let sourceString: String
            
            if contains(searchText: searchText, in: person.firstName) || contains(searchText: searchText, in: person.lastName){
                sourceString = person.fullName
            } else if contains(searchText: searchText, in: person.phoneNumber) {
                sourceString = person.phoneNumber
            } else if contains(searchText: searchText, in: person.email){
                sourceString = person.email
            } else {
                return false
            }
            
            resultStringsArray.append(getResultString(sourceString: sourceString, searchText: searchText))
            return true
        })
        return (filteredPersons, resultStringsArray)
    }
        
    static func isPersonsFullNameFirstCharEqual(firstPerson: Person, secondPerson: Person) -> Bool {
        return firstPerson.fullName.first == secondPerson.fullName.first
    }
}

private extension Search {
    
    static func contains (searchText: String, in source: String) -> Bool {
        return source.lowercased().contains(searchText.lowercased())
    }
    
    static func getResultString(sourceString: String, searchText: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: sourceString, attributes: Constants.grayColorAttribute)
        if let indexRange = sourceString.lowercased().range(of: searchText.lowercased()) {
            let range = NSRange(indexRange, in: sourceString)
            attributeString.setAttributes(Constants.blackColorAttribute, range: range)
        }
        return attributeString
    }
}
