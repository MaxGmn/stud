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
    private var fieldsValidationResult = [Bool]()
    private let picker = UIImagePickerController()
    
    private var cells = [CellType]()
    private var avatarImageView: UIImageView?
    
    var currentPersonForEditing: Person!
    var contactListDelegate: ContactListDelegate?
    var callback: ((Person) -> Void)?   
    
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
        picker.delegate = self
        if currentPersonForEditing == nil {
            currentPersonForEditing = Person()
            let addTitle = NSLocalizedString("ADD_VIEW_NAME", comment: "Add")
            navigationItem.title = addTitle
            if navigationItem.rightBarButtonItems?.count ?? 0 > 1 {
                navigationItem.rightBarButtonItems?.remove(at: 1)
            }
        }
        currentPersonCopy = (currentPersonForEditing!.copy() as! Person)
        fillFieldsValidationResult()
        changeSaveButtonAvailability()
        cellRegistration()
        cells = fillCellsArray(person: currentPersonCopy)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return cells.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = getCurentCell(at: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            changeImage(for: indexPath.row)
        case 7:
            showNoteTextView(index: indexPath.row)
        default:
            break
        }
        tableView.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UpdateController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        changeCurrentImage(imageState: .changed(newImage: choosenImage), for: 0)
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
    
    func fillFieldsValidationResult() {
        fieldsValidationResult = [Validation.isValidField(text: currentPersonCopy.firstName, kindOfField: .forTextField(maxLength: 20)),
                                  Validation.isValidField(text: currentPersonCopy.lastName, kindOfField: .forTextField(maxLength: 20)),
                                  Validation.isValidField(text: currentPersonCopy.phoneNumber, kindOfField: .forPhoneNumber),
                                  Validation.isValidField(text: currentPersonCopy.email, kindOfField: .forEmail)]
    }
    
    func changeSaveButtonAvailability() {
        saveButton.isEnabled = (!currentPersonForEditing.isEqual(currentPersonCopy) || imageState != ImageEditState.noChanges) &&
            fieldsValidationResult.firstIndex(of: false) == nil &&
            (!currentPersonCopy.firstName.isEmpty || !currentPersonCopy.lastName.isEmpty || !currentPersonCopy.phoneNumber.isEmpty || !currentPersonCopy.email.isEmpty)
    }
    
    func fillCellsArray (person: Person) -> [CellType] {
        let firstName = NSLocalizedString("FIRST_NAME_LABLE_TITLE", comment: "First name")
        let lastName = NSLocalizedString("LAST_NAME_LABLE_TITLE", comment: "Last name")
        let phone = NSLocalizedString("PHONE_LABLE_TITLE", comment: "Phone")
        let email = NSLocalizedString("EMAIL_LABLE_TITLE", comment: "Email")
        let birthday = NSLocalizedString("BIRTHDAY_LABLE_TITLE", comment: "Birthday")
        let height = NSLocalizedString("HEIGHT_LABLE_TITLE", comment: "Height")
        let note = NSLocalizedString("NOTE_LABLE_TITLE", comment: "Note")
        let driverLicense = NSLocalizedString("DRIVER_LICENSE_LABLE_TITLE", comment: "Driver license")
        
        var array: [CellType] = [.image(Presentation(dataType: .image(person.image))),
                                 .firstName(Presentation(keyboardType: .default, placeholder: firstName, title: firstName, dataType: .text(person.firstName))),
                                 .lastName(Presentation(keyboardType: .default, placeholder: lastName, title: lastName, dataType: .text(person.lastName))),
                                 .phone(Presentation(keyboardType: .numberPad, placeholder: phone, title: phone, dataType: .text(person.phoneNumber))),
                                 .email(Presentation(keyboardType: .emailAddress, placeholder: email, title: email, dataType: .text(person.email))),
                                 .birthday(Presentation(placeholder: birthday, title: birthday, dataType: .date(person.birthday))),
                                 .height(Presentation(placeholder: height, title: height, dataType: .integer(person.height))),
                                 .note(Presentation(keyboardType: .default, placeholder: note, title: note, dataType: .text(person.notes))),
                                 .driverLicenseSwitch(Presentation(title: driverLicense, dataType: .text(person.driverLicense)))]
        if !person.driverLicense.isEmpty {
            array.append(getDriverLicenseNumberCell())
        }
        return array
    }
    
    func getDriverLicenseNumberCell() -> CellType {
        let driverLicenseNumber = NSLocalizedString("DRIVER_LICENSE_NUMBER_LABLE_TITLE", comment: "Driver license number")
        return CellType.driverLicenseNumber(Presentation(keyboardType: .default, placeholder: driverLicenseNumber, title: driverLicenseNumber, dataType: .text(currentPersonCopy.driverLicense)))
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
            cell.callback = {[weak self] (cell, isOn) in
                let _ = self?.updatePersonInformation(index: indexPath.row, switchIsOn: isOn)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.setContent(cells[indexPath.row])
            cell.callback = {[weak self] (cell, text) in
                return self?.updatePersonInformation(index: indexPath.row, text: text)
            }
            return cell
        }
    }
    
    func updatePersonInformation(index: Int, text: String = "", switchIsOn: Bool = false) -> Bool?{
       
        switch cells[index] {
        case .image(var presentation):
            presentation.updateDataType(with: .image(currentPersonCopy.image))
            cells[index] = .image(presentation)
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        case .firstName(var presentation):
            fieldsValidationResult[0] = Validation.isValidField(text: text, kindOfField: .forTextField(maxLength: 20))
            if fieldsValidationResult[0] {
                currentPersonCopy.firstName = text
                presentation.updateDataType(with: .text(currentPersonCopy.firstName))
                cells[index] = .firstName(presentation)
            }
            changeSaveButtonAvailability()
            return fieldsValidationResult[0]
        case .lastName(var presentation):
            fieldsValidationResult[1] = Validation.isValidField(text: text, kindOfField: .forTextField(maxLength: 20))
            if fieldsValidationResult[1] {
                currentPersonCopy.lastName = text
                presentation.updateDataType(with: .text(currentPersonCopy.lastName))
                cells[index] = .lastName(presentation)
            }
            changeSaveButtonAvailability()
            return fieldsValidationResult[1]
        case .phone(var presentation):
            fieldsValidationResult[2] = Validation.isValidField(text: text, kindOfField: .forPhoneNumber)
            if fieldsValidationResult[2] {
                currentPersonCopy.phoneNumber = text
                presentation.updateDataType(with: .text(currentPersonCopy.phoneNumber))
                cells[index] = .phone(presentation)
            }
            changeSaveButtonAvailability()
            return fieldsValidationResult[2]
        case .email(var presentation):
            fieldsValidationResult[3] = Validation.isValidField(text: text, kindOfField: .forEmail)
            if fieldsValidationResult[3] {
                currentPersonCopy.email = text
                presentation.updateDataType(with: .text(currentPersonCopy.email))
                cells[index] = .email(presentation)
            }
            changeSaveButtonAvailability()
            return fieldsValidationResult[3]
        case .birthday(var presentation):
            presentation.updateDataType(with: .date(currentPersonCopy.birthday))
            cells[index] = .birthday(presentation)
            currentPersonCopy.birthday = Constants.dateFormat.date(from: text)
            tableView.endEditing(true)
        case .height(var presentation):
            presentation.updateDataType(with: .integer(currentPersonCopy.height))
            cells[index] = .height(presentation)
            currentPersonCopy.height = Int(text) ?? 0
        case .note(var presentation):
            currentPersonCopy.notes = text
            presentation.updateDataType(with: .text(currentPersonCopy.notes))
            cells[index] = .note(presentation)
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        case .driverLicenseSwitch:
            if switchIsOn {
                cells.append(getDriverLicenseNumberCell())
                tableView.insertRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
            } else {
                cells.removeLast()
                tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
                currentPersonCopy.driverLicense = ""
            }
        case .driverLicenseNumber(var presentation):
            currentPersonCopy.driverLicense = text
            presentation.updateDataType(with: .text(currentPersonCopy.driverLicense))
            cells[index] = .driverLicenseNumber(presentation)
        }
        changeSaveButtonAvailability()
        return nil
    }
        
    func changeImage(for index: Int) {
        if let _ = currentPersonCopy.image {
            let actionTitle = NSLocalizedString("CHANGE_IMAGE_TITLE", comment: "Choose action")
            let changeActionTitle = NSLocalizedString("CHANGE_IMAGE_ACTION", comment: "Change image")
            let removeActionTitle = NSLocalizedString("REMOVE_IMAGE_ACTION", comment: "Remove image")
            let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
            
            let choosePhotoAction = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
            let changeAction = UIAlertAction(title: changeActionTitle, style: .default) {action in self.runChooseImageHandler()}
            let removeAction = UIAlertAction(title: removeActionTitle, style: .destructive) {action in self.changeCurrentImage(imageState: .removed, for: index)}
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            
            choosePhotoAction.addAction(changeAction)
            choosePhotoAction.addAction(removeAction)
            choosePhotoAction.addAction(cancel)
            present(choosePhotoAction, animated: true, completion: nil)
        } else {
            runChooseImageHandler()
        }
    }
    
    func changeCurrentImage(imageState: ImageEditState, for index: Int) {
        switch imageState {
        case .removed:
            currentPersonCopy.image = nil
        case .changed(let newImage):
            currentPersonCopy.image = newImage
        default:
            break
        }
        
        self.imageState = imageState
        let _ = updatePersonInformation(index: index)
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
    
    func showNoteTextView(index: Int) {
        let destinationController = self.storyboard!.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        destinationController.currentText = currentPersonCopy.notes
        destinationController.callback = {[weak self] text in
            let _ = self?.updatePersonInformation(index: index, text: text)
        }
        present(destinationController, animated: true, completion: nil)
    }
}
