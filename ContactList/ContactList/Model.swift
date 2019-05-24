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
    static let userDefaultsKey = "groupedPersons"
    
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

enum RowKind {
    case imageRow(content: UIImage?)
    case textFieldRow(name: String, content: String)
    case switchRow(name: String, switchIsOn: Bool)
}

enum CellType {    
    case image(Presentation)
    case firstName(Presentation)
    case lastName(Presentation)
    case phone(Presentation)
    case email(Presentation)
    case birthday(Presentation)
    case height(Presentation)
    case note(Presentation)
    case driverLicenseSwitch(Presentation)
    case driverLicenseNumber(Presentation)
}

enum DataType {
    case image(UIImage?)
    case text(String)
    case date(Date?)
    case integer(Int)
}

struct Presentation {
    let keyboardType: UIKeyboardType?
    let placeholder: String?
    let title: String?
    var dataType: DataType
    
    init(keyboardType: UIKeyboardType? = nil, placeholder: String? = nil, title: String? = nil, dataType: DataType) {
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        self.title = title
        self.dataType = dataType
    }
    
    mutating func updateDataType(with dataType: DataType) {
        self.dataType = dataType
    }
}
