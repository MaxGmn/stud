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
    
    private var currentCellType: CellType!
    
    var callback: ((UITableViewCell, String) -> Void)?
    
    
    @IBAction func editingChangedAction(_ sender: Any) {
        callback?(self, fieldDataTextField.text ?? "")
    }  
    
    func setContent(_ cellType: CellType) {
        currentCellType = cellType
        fillContentByCellType()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

private extension TextTableViewCell {
    
    func fillContentByCellType() {
        
        guard let cellType = currentCellType else {return}
        
        switch cellType {
        case .firstName(let data):
            updateCellData(presentation: data)
        case .lastName(let data):
            updateCellData(presentation: data)
        case .phone(let data):
            updateCellData(presentation: data)
        case .email(let data):
            updateCellData(presentation: data)
        case .birthday(let data):
            updateCellData(presentation: data)
        case .height(let data):
            updateCellData(presentation: data)
        case .note(let data):
            updateCellData(presentation: data)
        case .driverLicenseNumber(let data):
            updateCellData(presentation: data)
        default:
            break
        }
    }
    
    func updateCellData(presentation: Presentation) {
        
        fieldNameLabel.text = presentation.title
        fieldDataTextField.placeholder = presentation.placeholder
        fieldDataTextField.backgroundColor = presentation.backgroundColor
        if let keyboardType = presentation.keyboardType {
            fieldDataTextField.keyboardType = keyboardType
        }
        
        switch presentation.dataType {
        case .text(let text):
            fieldDataTextField.text = text
        case .date(let date):
            fieldDataTextField.text = (date != nil ? Constants.dateFormat.string(from: date!) : Constants.defaultDate)
        case .integer(let number):
            fieldDataTextField.text = String(number)
        default:
            break
        }
    }
}
