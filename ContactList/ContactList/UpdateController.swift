//
//  UpdateController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/21/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class UpdateController: UITableViewController {
    
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var removeButton: UIBarButtonItem!
    
    private var imageState = ImageEditState.noChanges
    private var currentPersonCopy: Person!
    private var fieldsCheckingIsOk: Bool!
    private let heightArray = [Array(0...2), Array(0...9), Array(0...9)]
    private let datePicker = UIDatePicker()
    private let datePickerToolbar = UIToolbar()
    private let heightPicker = UIPickerView()
    private let heightPickerToolbar  = UIToolbar()
    
    private var cells = [CellType]()
    private var avatarImageView: UIImageView?
    
    var currentPersonForEditing: Person!
    var contactListDelegate: ContactListDelegate?
    var callback: ((Person) -> Void)?
    let picker = UIImagePickerController()
    
    
    @IBAction func saveAction(_ sender: Any) {
        DataManager.saveImage(by: imageState, name: currentPersonCopy.id)
        contactListDelegate?.updatePersonInformation(person: currentPersonCopy)
        callback?(currentPersonCopy)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        let actionTitle = NSLocalizedString("REMOVE_CONTACT_TITLE", comment: "Are you sure?")
        let removeTitle = NSLocalizedString("REMOVE_ACTION", comment: "Remove")
        let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
        
        let removeActionController = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
        let removeAction = UIAlertAction(title: removeTitle, style: .default) { action in
            self.contactListDelegate?.deletePerson(by: self.currentPersonCopy.id)
            self.navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        removeActionController.addAction(removeAction)
        removeActionController.addAction(cancelAction)
        present(removeActionController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = true
        picker.delegate = self
        
        if currentPersonForEditing == nil {
            currentPersonForEditing = Person()
        }
        currentPersonCopy = (currentPersonForEditing!.copy() as! Person)
        cellRegistration()
        cells = fillCellsArray(person: currentPersonCopy)
        addBirthdayDatePicker()
        addHeightPickerview()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return cells.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = getCurentCell(at: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            changeImage(for: indexPath)
        }
        tableView.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UpdateController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        changeCurrentImage(imageState: .changed(newImage: choosenImage), for: IndexPath(row: 0, section: 0))
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


private extension UpdateController {
    
    func cellRegistration() {
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchTableViewCell")
    }
    
    func fillCellsArray (person: Person) -> [CellType] {
        let array: [CellType] = [.image(Presentation(dataType: .image(person.image))),
                                 .firstName(Presentation(keyboardType: .default, placeholder: "First name", title: "First name", dataType: .text(person.firstName))),
                                 .lastName(Presentation(keyboardType: .default, placeholder: "Last name", title: "Last name", dataType: .text(person.lastName))),
                                 .phone(Presentation(keyboardType: .numberPad, placeholder: "Phone", title: "Phone", dataType: .text(person.phoneNumber))),
                                 .email(Presentation(keyboardType: .emailAddress, placeholder: "E-mail", title: "E-mail", dataType: .text(person.email))),
                                 .birthday(Presentation(placeholder: "Birthday", title: "Birthday", dataType: .date(person.birthday))),
                                 .height(Presentation(placeholder: "Height", title: "Height", dataType: .integer(person.height))),
                                 .note(Presentation(keyboardType: .default, placeholder: "Note", title: "Note", dataType: .text(person.notes))),
                                 .driverLicenseSwitch(Presentation(title: "Driver license", dataType: .text(person.driverLicense))),
                                 .driverLicenseNumber(Presentation(keyboardType: .default, placeholder: "Driver license number", title: "Driver license number", dataType: .text(person.driverLicense)))]
        return array
    }
    
    func getCurentCell(at indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.setContent(cells[indexPath.row])
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
            cell.setContent(cells[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            switch indexPath.row {
            case 5:
                cell.setContent(cells[indexPath.row], datePicker: datePicker, pickerToolbar: datePickerToolbar)
            case 6:
                cell.setContent(cells[indexPath.row], heightPicker: heightPicker, pickerToolbar: heightPickerToolbar)
            default:
                cell.setContent(cells[indexPath.row])
            }
            cell.callback = {(cell, text) in
                if let indexPath = self.tableView.indexPath(for: cell) {
                    self.updatePersonInformation(text: text, indexPath: indexPath)
                }
            }
            return cell
            
        }
    }
    
    func updatePersonInformation(text: String = "", indexPath: IndexPath) {
        
        let index = indexPath.row
        
        switch cells[index] {
        case .image(var presentation):
            presentation.updateDataType(with: .image(currentPersonCopy.image))
            cells[index] = .image(presentation)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .firstName(var presentation):
            currentPersonCopy.firstName = text
            presentation.updateDataType(with: .text(currentPersonCopy.firstName))
            cells[index] = .firstName(presentation)
        case .lastName(var presentation):
            currentPersonCopy.lastName = text
            presentation.updateDataType(with: .text(currentPersonCopy.lastName))
            cells[index] = .lastName(presentation)
        case .phone(var presentation):
            currentPersonCopy.phoneNumber = text
            presentation.updateDataType(with: .text(currentPersonCopy.phoneNumber))
            cells[index] = .phone(presentation)
        case .email(var presentation):
            currentPersonCopy.email = text
            presentation.updateDataType(with: .text(currentPersonCopy.email))
            cells[index] = .email(presentation)
        case .birthday(var presentation):
            presentation.updateDataType(with: .date(currentPersonCopy.birthday))
            cells[index] = .birthday(presentation)
        case .height(var presentation):
            presentation.updateDataType(with: .integer(currentPersonCopy.height))
            cells[index] = .height(presentation)
        case .note(var presentation):
            currentPersonCopy.notes = text
            presentation.updateDataType(with: .text(currentPersonCopy.notes))
            cells[index] = .note(presentation)
        case .driverLicenseSwitch(var presentation):
            presentation.updateDataType(with: .text(currentPersonCopy.driverLicense))
            cells[index] = .driverLicenseSwitch(presentation)
        case .driverLicenseNumber(var presentation):
            currentPersonCopy.driverLicense = text
            presentation.updateDataType(with: .text(currentPersonCopy.driverLicense))
            cells[index] = .driverLicenseNumber(presentation)
        }
    }
        
    func changeImage(for indexPath: IndexPath) {
        
        if let _ = currentPersonCopy.image {
            let actionTitle = NSLocalizedString("CHANGE_IMAGE_TITLE", comment: "Choose action")
            let changeActionTitle = NSLocalizedString("CHANGE_IMAGE_ACTION", comment: "Change image")
            let removeActionTitle = NSLocalizedString("REMOVE_IMAGE_ACTION", comment: "Remove image")
            let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
            
            let choosePhotoAction = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
            let changeAction = UIAlertAction(title: changeActionTitle, style: .default) {action in self.runChooseImageHandler()}
            let removeAction = UIAlertAction(title: removeActionTitle, style: .destructive) {action in self.changeCurrentImage(imageState: .removed, for: indexPath)}
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            
            choosePhotoAction.addAction(changeAction)
            choosePhotoAction.addAction(removeAction)
            choosePhotoAction.addAction(cancel)
            present(choosePhotoAction, animated: true, completion: nil)
        } else {
            runChooseImageHandler()
        }
    }
    
    func changeCurrentImage(imageState: ImageEditState, for indexPath: IndexPath) {
        switch imageState {
        case .removed:
            currentPersonCopy.image = nil
        case .changed(let newImage):
            currentPersonCopy.image = newImage
        default:
            break
        }
        
        self.imageState = imageState
        updatePersonInformation(indexPath: indexPath)
//        changeSaveButtonAvailability()
    }
    
    func runChooseImageHandler() {
        #if targetEnvironment(simulator)
        showPhotoLibrary()
        #else
        
        let actionTitle = NSLocalizedString("CHANGE_SOURCE_TITLE", comment: "Choose image source")
        let galleryActionTitle = NSLocalizedString("GALLERY_ACTION", comment: "Gallery")
        let cameraActionTitle = NSLocalizedString("CAMERA_ACTION", comment: "Camera")
        let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
        
        let alertController = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: galleryActionTitle, style: .default){action in self.showPhotoLibrary()}
        let cameraAction = UIAlertAction(title: cameraActionTitle, style: .default){action in self.runCamera()}
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        #endif
    }
    
    func showPhotoLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(self.picker, animated: true, completion: nil)
    }
    
    func runCamera() {
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(self.picker, animated: true, completion: nil)
    }
    
    func addBirthdayDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.setDate(currentPersonCopy.birthday ?? Date(), animated: true)
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Constants.dateFormat.date(from: Constants.defaultDate)
        datePickerToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDateButtonAction))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
        let emptyButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        datePickerToolbar.setItems([cancelButton, emptyButton, doneButton], animated: true)
    }
    
    @objc func doneDateButtonAction(){
        currentPersonCopy.birthday = datePicker.date
        let indexPath = IndexPath(row: 5, section: 0)
        updatePersonInformation(indexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.tableView.endEditing(true)
    }
    
    @objc func cancelButtonAction(){
        self.tableView.endEditing(true)
    }
    
    func addHeightPickerview() {
        heightPicker.dataSource = self
        heightPicker.delegate = self
        if currentPersonCopy.height > 0 {
            let firstNumber = currentPersonCopy.height / 100
            let secondNumber = currentPersonCopy.height / 10 - firstNumber * 10
            let thirdNumber = currentPersonCopy.height % 10
            heightPicker.selectRow(firstNumber, inComponent: 0, animated: true)
            heightPicker.selectRow(secondNumber, inComponent: 1, animated: true)
            heightPicker.selectRow(thirdNumber, inComponent: 2, animated: true)
        }
        heightPickerToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickerViewButtonAction))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
        let emptyButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        heightPickerToolbar.setItems([cancelButton, emptyButton, doneButton], animated: true)

    }
    
    @objc func donePickerViewButtonAction(){
        let firstNumber = heightArray[0][heightPicker.selectedRow(inComponent: 0)]
        let secondNumber = heightArray[1][heightPicker.selectedRow(inComponent: 1)]
        let thirdNumber = heightArray[2][heightPicker.selectedRow(inComponent: 2)]
        currentPersonCopy.height = firstNumber * 100 + secondNumber * 10 + thirdNumber
        let indexPath = IndexPath(row: 6, section: 0)
        updatePersonInformation(indexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.tableView.endEditing(true)
    }
}

extension UpdateController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return heightArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heightArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(heightArray[component][row])
    }
}
