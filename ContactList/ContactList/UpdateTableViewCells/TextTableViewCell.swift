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
    
    private let datePicker = UIDatePicker()
    private let heightPicker = UIPickerView()
    private let heightArray = [Array(0...2), Array(0...9), Array(0...9)]
    private var height: Int?
    private var birthday: Date?
    private var cellType: CellType!
    
    var callback: ((CellType, Any?) -> Bool?)?
        
    @IBAction func editingChangedAction(_ sender: Any) {
        if let result = callback?(cellType, dataTextField.text ?? "") {
            dataTextField.backgroundColor = result.color
        }
    }  
    
    func setContent(_ presentation: Presentation) {
        cellType = presentation.cellType
        updateCellData(presentation: presentation)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

private extension TextTableViewCell {
    
    func updateCellData(presentation: Presentation) {
        
        nameLabel.text = presentation.title
        dataTextField.placeholder = presentation.placeholder
        dataTextField.isEnabled = presentation.cellType != .notes
        if let keyboardType = presentation.keyboardType {
            dataTextField.keyboardType = keyboardType
        }
        
        switch presentation.dataType {
        case .text(let text):
            dataTextField.text = text
        case .date(let date):
            self.birthday = date
            let formatter = DateFormatter()
            formatter.dateFormat = Constants.dateFormat
            dataTextField.text = (date != nil ? formatter.string(from: date!) : Constants.defaultDate)
            addBirthdayDatePicker()
        case .integer(let number):
            self.height = number
            dataTextField.text = String(number)
            addHeightPickerview()
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
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        datePicker.minimumDate = formatter.date(from: Constants.defaultDate)
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
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        dataTextField.text = birthday != nil ? formatter.string(from: birthday!) : Constants.defaultDate
        let _ = callback?(cellType, birthday)
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
        let result = firstNumber * 100 + secondNumber * 10 + thirdNumber
        dataTextField.text = String(result)
        let _ = callback?(cellType, result)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(heightArray[component][row])
    }    
}
