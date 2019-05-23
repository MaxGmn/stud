//
//  TextTableViewCell.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/21/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dataTextField: UITextField!
    
    private var currentCellType: CellType!
    private var datePicker: UIDatePicker?
    private var heightPicker: UIPickerView?
    private var pickerToolbar: UIToolbar?
    
    var callback: ((UITableViewCell, String) -> Bool?)?
    
    
    @IBAction func editingChangedAction(_ sender: Any) {
        if let result = callback?(self, dataTextField.text ?? "") {
            dataTextField.backgroundColor = result.color
        }
    }  
    
    func setContent(_ cellType: CellType, datePicker: UIDatePicker? = nil, heightPicker: UIPickerView? = nil, pickerToolbar: UIToolbar? = nil) {
        currentCellType = cellType
        self.datePicker = datePicker
        self.heightPicker = heightPicker
        self.pickerToolbar = pickerToolbar
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
        
        nameLabel.text = presentation.title
        dataTextField.placeholder = presentation.placeholder
        dataTextField.backgroundColor = presentation.backgroundColor
        if let keyboardType = presentation.keyboardType {
            dataTextField.keyboardType = keyboardType
        }
        
        
        dataTextField.inputView = datePicker ?? heightPicker
        dataTextField.inputAccessoryView = pickerToolbar
        
        
        switch presentation.dataType {
        case .text(let text):
            dataTextField.text = text
        case .date(let date):
            dataTextField.text = (date != nil ? Constants.dateFormat.string(from: date!) : Constants.defaultDate)
        case .integer(let number):
            dataTextField.text = String(number)
        default:
            break
        }
    }
}
