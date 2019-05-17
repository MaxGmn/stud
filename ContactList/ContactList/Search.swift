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
            
            if isContains(searchText: searchText, in: person.firstName!) || isContains(searchText: searchText, in: person.lastName!){
                sourceString = getFullNameString(from: person)
            } else if isContains(searchText: searchText, in: person.phoneNumber!) {
                sourceString = person.phoneNumber!
            } else if isContains(searchText: searchText, in: person.email!){
                sourceString = person.email!
            } else {
                return false
            }
            
            resultStringsArray.append(getResultString(sourceString: sourceString, searchText: searchText))
            return true
        })
        return (filteredPersons, resultStringsArray)
    }
    
    static func getPersonsArrayFromDictionary(from dictionary: [String : [Person]]) -> [Person] {
        var resultArray = [Person]()
        for item in dictionary {
            resultArray += item.value
        }
        return resultArray
    }
    
    static func isPersonsFullNameFirstCharCompare(firstPerson: Person, secondPerson: Person) -> Bool {
        return getFullNameString(from: firstPerson).first == getFullNameString(from: secondPerson).first
    }
    
    static func getFullNameString(from person: Person) -> String {
        return person.firstName! + (person.firstName!.isEmpty ? "" : " ") + person.lastName!
    }
    
    private static func isContains (searchText: String, in source: String) -> Bool {
        return source.lowercased().contains(searchText.lowercased())
    }
    
    private static func getResultString(sourceString: String, searchText: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: sourceString, attributes: Constants.grayTextColor)
        if let indexRange = sourceString.lowercased().range(of: searchText.lowercased()) {
            let range = NSRange(indexRange, in: sourceString)
            attributeString.setAttributes(Constants.blackTextColor, range: range)
        }
        return attributeString
    }
}
