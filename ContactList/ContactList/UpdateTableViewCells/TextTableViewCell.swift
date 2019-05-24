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
    private let datePicker = UIDatePicker()
    private let heightPicker = UIPickerView()
    private let heightArray = [Array(0...2), Array(0...9), Array(0...9)]
    private var height: Int?
    private var birthday: Date?
    
    var callback: ((UITableViewCell, String) -> Bool?)?
        
    @IBAction func editingChangedAction(_ sender: Any) {
        if let result = callback?(self, dataTextField.text ?? "") {
            dataTextField.backgroundColor = result.color
        }
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
            addBirthdayDatePicker()
        case .height(let data):
            updateCellData(presentation: data)
            addHeightPickerview()
        case .note(let data):
            updateCellData(presentation: data, textFieldIsEnable: false)
        case .driverLicenseNumber(let data):
            updateCellData(presentation: data)
        default:
            break
        }
    }
    
    func updateCellData(presentation: Presentation, textFieldIsEnable: Bool = true) {
        
        nameLabel.text = presentation.title
        dataTextField.placeholder = presentation.placeholder
        dataTextField.isEnabled = textFieldIsEnable
        if let keyboardType = presentation.keyboardType {
            dataTextField.keyboardType = keyboardType
        }
        
        switch presentation.dataType {
        case .text(let text):
            dataTextField.text = text
        case .date(let date):
            self.birthday = date
            dataTextField.text = (date != nil ? Constants.dateFormat.string(from: date!) : Constants.defaultDate)
        case .integer(let number):
            self.height = number
            dataTextField.text = String(number)
        default:
            break
        }
    }
    
    func addHeightPickerview() {
        guard let currentHeight = height else {return}
        
        heightPicker.dataSource = self
        heightPicker.delegate = self
        if currentHeight > 0 {
            let firstNumber = currentHeight / 100
            let secondNumber = currentHeight / 10 - firstNumber * 10
            let thirdNumber = currentHeight % 10
            heightPicker.selectRow(firstNumber, inComponent: 0, animated: true)
            heightPicker.selectRow(secondNumber, inComponent: 1, animated: true)
            heightPicker.selectRow(thirdNumber, inComponent: 2, animated: true)
        }
        dataTextField.inputView = heightPicker
    }
    
    func addBirthdayDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.setDate(birthday ?? Date(), animated: true)
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Constants.dateFormat.date(from: Constants.defaultDate)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDateButtonAction))
        let emptyButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([emptyButton, doneButton], animated: true)
        dataTextField.inputView = datePicker
        dataTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneDateButtonAction(){
        birthday = datePicker.date
        dataTextField.text = birthday != nil ? Constants.dateFormat.string(from: birthday!) : Constants.defaultDate
        let _ = callback?(self, dataTextField.text ?? "")
    }
}

extension TextTableViewCell : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return heightArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heightArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let firstNumber = heightArray[0][pickerView.selectedRow(inComponent: 0)]
        let secondNumber = heightArray[1][pickerView.selectedRow(inComponent: 1)]
        let thirdNumber = heightArray[2][pickerView.selectedRow(inComponent: 2)]
        let resultString = String(firstNumber * 100 + secondNumber * 10 + thirdNumber)
        dataTextField.text = resultString
        let _ = callback?(self, resultString)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(heightArray[component][row])
    }    
}
