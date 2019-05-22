//
//  TextTableViewCell.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/21/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet private weak var fieldNameLabel: UILabel!
    @IBOutlet private weak var fieldDataTextField: UITextField!    
    
    var person: Person!
    
    func setContent(labelName: String, content: String) {
        fieldNameLabel.text = labelName
        fieldDataTextField.text = content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
