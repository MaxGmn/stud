//
//  SwitchTableViewCell.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/21/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!    
    @IBOutlet private weak var showFieldSwitch: UISwitch!    
    
    var person: Person!
    
    func setContent(_ cellType: CellType) {
        switch cellType {
        case .driverLicenseSwitch(let data):
            updateCellData(presentation: data)
        default:
            break
        }
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

private extension SwitchTableViewCell {
    
    func updateCellData(presentation: Presentation) {
        nameLabel.text = presentation.title
        switch presentation.dataType {
        case .text(let text):
            showFieldSwitch.isOn = !text.isEmpty
        default:
            break
        }
    }
}
