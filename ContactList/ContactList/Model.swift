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
    static let dateFormat = "dd.MM.yyyy"
    static let userDefaultsKey = "groupedPersons"
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

enum CellType: String {    
    case image
    case firstName
    case lastName
    case phoneNumber
    case email
    case birthday
    case height
    case notes
    case driverLicenseSwitch
    case driverLicense
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
    let cellType: CellType
    let validationType: ValidationFunctions?
    
    init(keyboardType: UIKeyboardType? = nil, placeholder: String? = nil, title: String? = nil, dataType: DataType, cellType: CellType, validationType: ValidationFunctions? = nil) {
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        self.title = title
        self.dataType = dataType
        self.cellType = cellType
        self.validationType = validationType
    }
    
    mutating func updateDataType(_ dataType: DataType, with data: Any?) {
        let newDataType: DataType
        
        switch dataType {
        case .image:
            newDataType = .image(data as? UIImage)
        case .integer:
            newDataType = .integer(data as! Int)
        case .date:
            newDataType = .date(data as? Date)
        default:
            newDataType = .text(data as! String)
        }
        
        self.dataType = newDataType
    }
}
