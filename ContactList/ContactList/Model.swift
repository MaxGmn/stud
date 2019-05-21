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
    static let grayColorAttribute = [NSAttributedString.Key.foregroundColor: UIColor.gray]
    static let blackColorAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
    static let defaultDate = "01.01.1900"
    static let dateFormat = getDateFormatter()
    
    private static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

extension Bool {
    var color: UIColor {
        return self ? Constants.validColor : Constants.invalidColor
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
