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
    
    var callback: ((UITableViewCell, Bool) -> Void)?
    
    func setContent(_ presentation: Presentation) {
        if presentation.cellType == .driverLicenseSwitch {
            updateCellData(presentation: presentation)
        }
    }
    
    @IBAction func switchOnAction(_ sender: Any) {
        callback?(self, showFieldSwitch.isOn)
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
