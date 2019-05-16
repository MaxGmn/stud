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
    static let grayTextColor = [NSAttributedString.Key.foregroundColor: UIColor.gray]
    static let blackTextColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
