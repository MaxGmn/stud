//
//  TableViewCell.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/7/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellNameLabel: UILabel!
    
    @IBOutlet weak var cellContactLabel: UILabel!
    
    func updateWith (contact: Person) {
        cellImage.image = CellFieldsBuilder.getImage(image: contact.image)
        cellNameLabel.text = CellFieldsBuilder.getName(firstName: contact.firstName!, lastName: contact.lastName!)
        cellContactLabel.text = CellFieldsBuilder.getContact(phoneNumber: contact.phoneNumber!, email: contact.email!)
    }
}
