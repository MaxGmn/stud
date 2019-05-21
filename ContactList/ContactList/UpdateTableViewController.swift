//
//  UpdateTableViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/20/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class UpdateTableViewController: UITableViewController {
    
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var removeButton: UIBarButtonItem!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var birthdayTextField: UITextField!
    @IBOutlet private weak var heightTextField: UITextField!
    @IBOutlet private weak var notesTextField: UITextField!
    @IBOutlet private weak var driverLicenseSvitch: UISwitch!
    @IBOutlet private weak var driverLicenseTextField: UITextField!
    @IBOutlet private weak var driverLicenseNumberCell: UITableViewCell!
    
    private var imageState = ImageEditState.noChanges
    private var currentPersonCopy: Person!
    private var fieldsCheckingIsOk: Bool!
    private let heightArray = [Array(0...2), Array(0...9), Array(0...9)]
    private let datePicker = UIDatePicker()
    
    var currentPersonForEditing: Person!
    var contactListDelegate: ContactListDelegate?
    var callback: ((Person) -> Void)?
    let picker = UIImagePickerController()
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        DataManager.saveImage(by: imageState, name: currentPersonCopy.id)
        contactListDelegate?.updatePersonInformation(person: currentPersonCopy)
        callback?(currentPersonCopy)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeButtonAction(_ sender: Any) {
        contactListDelegate?.deletePerson(by: currentPersonCopy.id)
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func versionComparsion(_ sender: Any) {
        changeCurrentPersonCopy()
        fieldsCheckingIsOk = allFieldsAreValid() && atLeastOneFieldIsFilled()
        changeSaveButtonAvailability()
    }
    
    @IBAction func driverLicenseSwitcherAction(_ sender: Any) {
        showDriverLicenseNumberCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentPersonForEditing == nil {
            currentPersonForEditing = Person()
            removeButton.isEnabled = false
        }
        currentPersonCopy = (currentPersonForEditing!.copy() as! Person)
        fillTextFields()
        fieldsCheckingIsOk = allFieldsAreValid() && atLeastOneFieldIsFilled()
        addImagePicker()
        addHeightPickerview()
        addBirthdayDatePicker()
        showDriverLicenseNumberCell()
    }
}

extension UpdateTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        changeCurrentImage(imageState: .changed(newImage: choosenImage))
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UpdateTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == notesTextField {
            showNoteTextView()
            return false
        }
        return true
    }
}

extension UpdateTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return heightArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heightArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(heightArray[component][row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let firstNumber = heightArray[0][pickerView.selectedRow(inComponent: 0)]
        let secondNumber = heightArray[1][pickerView.selectedRow(inComponent: 1)]
        let thirdNumber = heightArray[2][pickerView.selectedRow(inComponent: 2)]
        let resultNumber = firstNumber * 100 + secondNumber * 10 + thirdNumber
        heightTextField.text = "\(resultNumber)"
    }    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }
}

private extension UpdateTableViewController {
    
    func changeCurrentPersonCopy() {
        currentPersonCopy.firstName = firstNameTextField.text ?? ""
        currentPersonCopy.lastName = lastNameTextField.text ?? ""
        currentPersonCopy.phoneNumber = phoneNumberTextField.text ?? ""
        currentPersonCopy.email = emailTextField.text ?? ""        
        currentPersonCopy.birthday = Constants.dateFormat.date(from: birthdayTextField.text!)
        currentPersonCopy.height = Int(heightTextField.text ?? "")!
        currentPersonCopy.notes = notesTextField.text ?? ""
        currentPersonCopy.driverLicense = driverLicenseTextField.text ?? ""
    }
    
    func fillTextFields() {
        avatarImageView.image = currentPersonCopy.image ?? Constants.emptyAvatar
        firstNameTextField.text = currentPersonCopy.firstName
        lastNameTextField.text = currentPersonCopy.lastName
        phoneNumberTextField.text = currentPersonCopy.phoneNumber
        emailTextField.text = currentPersonCopy.email
        birthdayTextField.text = currentPersonCopy.birthday != nil ? Constants.dateFormat.string(from: currentPersonCopy.birthday!) : ""
        heightTextField.text = "\(currentPersonCopy.height)"
        notesTextField.text = currentPersonCopy.notes
        driverLicenseTextField.text = currentPersonCopy.driverLicense
        driverLicenseSvitch.isOn = !currentPersonCopy.driverLicense.isEmpty
        
    }
    
    func allFieldsAreValid() -> Bool {
        let firstNameValidationResult = Validation.isValidField(text: currentPersonCopy.firstName, kindOfField: .forTextField(maxLength: 20))
        firstNameTextField.backgroundColor = firstNameValidationResult.color
        
        let lastNameValidationResult = Validation.isValidField(text: currentPersonCopy.lastName, kindOfField: .forTextField(maxLength: 20))
        lastNameTextField.backgroundColor = lastNameValidationResult.color
        
        let phoneNumberValidationResult = Validation.isValidField(text: currentPersonCopy.phoneNumber, kindOfField: .forPhoneNumber)
        phoneNumberTextField.backgroundColor = phoneNumberValidationResult.color
        
        let emailValidationResult = Validation.isValidField(text: currentPersonCopy.email, kindOfField: .forEmail)
        emailTextField.backgroundColor = emailValidationResult.color
        
        return firstNameValidationResult && lastNameValidationResult && phoneNumberValidationResult && emailValidationResult
    }
    
    func atLeastOneFieldIsFilled() -> Bool {
        let firstNameIsNotEmpty = !currentPersonCopy.firstName.isEmpty
        let lastNameIsNotEmpty = !currentPersonCopy.lastName.isEmpty
        let phoneNumberIsNotEmpty = !currentPersonCopy.phoneNumber.isEmpty
        let emailIsNotEmpty = !currentPersonCopy.email.isEmpty
        
        return firstNameIsNotEmpty || lastNameIsNotEmpty || phoneNumberIsNotEmpty || emailIsNotEmpty
    }
    
    func changeSaveButtonAvailability() {
        saveButton.isEnabled = (currentPersonForEditing != currentPersonCopy || imageState != ImageEditState.noChanges) && fieldsCheckingIsOk
    }
    
    func showDriverLicenseNumberCell() {
        driverLicenseNumberCell.isHidden = !driverLicenseSvitch.isOn
    }
    
    func addImagePicker() {
        picker.delegate = self
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(tapGuestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(recognizer)
        avatarImageView.contentMode = .scaleAspectFit
    }
    
    func addHeightPickerview() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        if currentPersonCopy.height > 0 {
            let firstNumber = currentPersonCopy.height / 100
            let secondNumber = currentPersonCopy.height / 10 - firstNumber * 10
            let thirdNumber = currentPersonCopy.height % 10
            pickerView.selectRow(firstNumber, inComponent: 0, animated: true)
            pickerView.selectRow(secondNumber, inComponent: 1, animated: true)
            pickerView.selectRow(thirdNumber, inComponent: 2, animated: true)
        }        
        let pickerViewToolbar = UIToolbar()
        pickerViewToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickerViewButtonAction))
        pickerViewToolbar.setItems([doneButton], animated: true)
        heightTextField.inputAccessoryView = pickerViewToolbar
        heightTextField.inputView = pickerView
    }
    
    @objc func donePickerViewButtonAction(){
        
        self.tableView.endEditing(true)
    }
    
    func addBirthdayDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.setDate(currentPersonCopy.birthday ?? Date(), animated: true)
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Constants.dateFormat.date(from: Constants.defaultDate)
        let datePickerToolbar = UIToolbar()
        datePickerToolbar.sizeToFit()
        let doneDateButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDateButtonAction))
        let cancelDateButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDateButtonAction))
        datePickerToolbar.setItems([doneDateButton, cancelDateButton], animated: true)
        birthdayTextField.inputAccessoryView = datePickerToolbar
        birthdayTextField.inputView = datePicker
    }
    
    func showNoteTextView() {
        let destinationController = self.storyboard!.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        destinationController.currentText = currentPersonCopy.notes
        destinationController.callback = { text in
            self.currentPersonCopy.notes = text
            self.notesTextField.text = text
            self.tableView.endEditing(true)
            self.changeSaveButtonAvailability()
        }
        present(destinationController, animated: true, completion: nil)
    }
    
    @objc func doneDateButtonAction(){
        birthdayTextField.text = Constants.dateFormat.string(from: datePicker.date)
        self.tableView.endEditing(true)
    }
    
    @objc func cancelDateButtonAction(){
        self.tableView.endEditing(true)
    }
    
    
    @objc func onImageTap (tapGuestureRecognizer: UITapGestureRecognizer) {
        
        if let _ = currentPersonCopy.image {
            
            let actionTitle = NSLocalizedString("CHANGE_IMAGE_TITLE", comment: "Choose action")
            let changeActionTitle = NSLocalizedString("CHANGE_IMAGE_ACTION", comment: "Change image")
            let removeActionTitle = NSLocalizedString("REMOVE_IMAGE_ACTION", comment: "Remove image")
            let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
            
            let choosePhotoAction = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
            let changeAction = UIAlertAction(title: changeActionTitle, style: .default) {action in self.runChooseImageHandler()}
            let removeAction = UIAlertAction(title: removeActionTitle, style: .destructive) {action in self.changeCurrentImage(imageState: .removed)}
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            
            choosePhotoAction.addAction(changeAction)
            choosePhotoAction.addAction(removeAction)
            choosePhotoAction.addAction(cancel)
            present(choosePhotoAction, animated: true, completion: nil)
        } else {
            runChooseImageHandler()
        }
    }
    
    func changeCurrentImage(imageState: ImageEditState) {
        switch imageState {
        case .removed:
            avatarImageView.image = Constants.emptyAvatar
            currentPersonCopy.image = nil
        case .changed(let newImage):
            avatarImageView.image = newImage
            currentPersonCopy.image = newImage
        default:
            break
        }
        
        self.imageState = imageState
        changeSaveButtonAvailability()
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
}
