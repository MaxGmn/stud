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
    
    private var cells = [Presentation]()
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
        fieldsValidationResult = Array(repeating: true, count: 10)
        changeSaveButtonAvailability()
        cellRegistration()
        cells = fillCellsArray(person: currentPersonCopy)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return cells.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = getCell(at: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cells[indexPath.row].cellType
        switch indexPath.row {
        case 0:
            changeImage(for: cellType)
        case 7:
            showNoteTextView(for: cellType)
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
        changeCurrentImage(imageState: .changed(newImage: choosenImage), for: .image)
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
    
    func changeSaveButtonAvailability() {
        saveButton.isEnabled = (!currentPersonForEditing.isEqual(currentPersonCopy) || imageState != ImageEditState.noChanges) &&
            fieldsValidationResult.firstIndex(of: false) == nil &&
            (!currentPersonCopy.firstName.isEmpty || !currentPersonCopy.lastName.isEmpty || !currentPersonCopy.phoneNumber.isEmpty || !currentPersonCopy.email.isEmpty)
    }
    
    func fillCellsArray (person: Person) -> [Presentation] {
        let firstName = NSLocalizedString("FIRST_NAME_LABLE_TITLE", comment: "First name")
        let lastName = NSLocalizedString("LAST_NAME_LABLE_TITLE", comment: "Last name")
        let phone = NSLocalizedString("PHONE_LABLE_TITLE", comment: "Phone")
        let email = NSLocalizedString("EMAIL_LABLE_TITLE", comment: "Email")
        let birthday = NSLocalizedString("BIRTHDAY_LABLE_TITLE", comment: "Birthday")
        let height = NSLocalizedString("HEIGHT_LABLE_TITLE", comment: "Height")
        let note = NSLocalizedString("NOTE_LABLE_TITLE", comment: "Note")
        let driverLicense = NSLocalizedString("DRIVER_LICENSE_LABLE_TITLE", comment: "Driver license")
        
        
        var array: [Presentation] = [(Presentation(dataType: .image(person.image), cellType: .image)),
                                 (Presentation(keyboardType: .default, placeholder: firstName, title: firstName, dataType: .text(person.firstName), cellType: .firstName, validationType: .forTextField(maxLength: 20))),
                                 (Presentation(keyboardType: .default, placeholder: lastName, title: lastName, dataType: .text(person.lastName), cellType: .lastName, validationType: .forTextField(maxLength: 20))),
                                 (Presentation(keyboardType: .numberPad, placeholder: phone, title: phone, dataType: .text(person.phoneNumber), cellType: .phoneNumber, validationType: .forPhoneNumber)),
                                 (Presentation(keyboardType: .emailAddress, placeholder: email, title: email, dataType: .text(person.email), cellType: .email, validationType: .forEmail)),
                                 (Presentation(placeholder: birthday, title: birthday, dataType: .date(person.birthday), cellType: .birthday)),
                                 (Presentation(placeholder: height, title: height, dataType: .integer(person.height), cellType: .height)),
                                 (Presentation(placeholder: note, title: note, dataType: .text(person.notes), cellType: .notes)),
                                 (Presentation(title: driverLicense, dataType: .text(person.driverLicense), cellType: .driverLicenseSwitch))]
        if !person.driverLicense.isEmpty {
            array.append(getDriverLicenseNumberCell())
        }
        return array
    }
    
    func getDriverLicenseNumberCell() -> Presentation {
        let driverLicenseNumber = NSLocalizedString("DRIVER_LICENSE_NUMBER_LABLE_TITLE", comment: "Driver license number")
        return Presentation(keyboardType: .default, placeholder: driverLicenseNumber, title: driverLicenseNumber, dataType: .text(currentPersonCopy.driverLicense), cellType: .driverLicense)
    }
    
    func getCell(at indexPath: IndexPath) -> UITableViewCell {
        
        let presentation = cells[indexPath.row]
        switch presentation.cellType {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.setContent(presentation)
            return cell
        case .driverLicenseSwitch:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
            cell.setContent(presentation)
            cell.callback = {[weak self] (cellType, isOn) in
                let _ = self?.updatePersonInformation(cellType, data: isOn)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.setContent(presentation)
            cell.callback = {[weak self] (cellType, data) in
                return self?.updatePersonInformation(cellType, data: data)
            }
            return cell
        }
    }
    
    
    func updatePersonInformation(_ cellType: CellType, data: Any?) -> Bool?{
        
        guard let index = cells.firstIndex(where: {$0.cellType == cellType}) else {
            return nil
        }
        
        var validationResult: Bool?
        
        if cellType == .driverLicenseSwitch {
            if data is Bool && data as! Bool {
                cells.append(getDriverLicenseNumberCell())
                if let indexPath = getDriverLicenseIndexPath() {
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            } else {
                if let indexPath = getDriverLicenseIndexPath() {
                    cells.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    currentPersonCopy.driverLicense = ""
                }
            }
        } else {
            cells[index].updateDataType(cells[index].dataType, with: data)
            
            if let validationType = cells[index].validationType {
                if data is String{
                    fieldsValidationResult[index] = Validation.isValidField(text: data as! String, kindOfField: validationType)
                    validationResult = fieldsValidationResult[index]
                }
            }
            
            currentPersonCopy.setValue(data, forKey: cellType.rawValue)
            
            switch cellType {
            case .image, .notes:
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            case .birthday:
                tableView.endEditing(true)
            default:
                break
            }
        }
        changeSaveButtonAvailability()
        return validationResult
    }
    
    func getDriverLicenseIndexPath() -> IndexPath? {
        guard let driverLicenseIndex = cells.firstIndex(where: {$0.cellType == .driverLicense}) else {
            return nil
        }
        return IndexPath(row: driverLicenseIndex, section: 0)
    }
    
    func changeImage(for cellType: CellType) {
        if let _ = currentPersonCopy.image {
            let actionTitle = NSLocalizedString("CHANGE_IMAGE_TITLE", comment: "Choose action")
            let changeActionTitle = NSLocalizedString("CHANGE_IMAGE_ACTION", comment: "Change image")
            let removeActionTitle = NSLocalizedString("REMOVE_IMAGE_ACTION", comment: "Remove image")
            let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
            
            let choosePhotoAction = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
            let changeAction = UIAlertAction(title: changeActionTitle, style: .default) {action in self.runChooseImageHandler()}
            let removeAction = UIAlertAction(title: removeActionTitle, style: .destructive) {action in self.changeCurrentImage(imageState: .removed, for: cellType)}
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            
            choosePhotoAction.addAction(changeAction)
            choosePhotoAction.addAction(removeAction)
            choosePhotoAction.addAction(cancel)
            present(choosePhotoAction, animated: true, completion: nil)
        } else {
            runChooseImageHandler()
        }
    }
    
    func changeCurrentImage(imageState: ImageEditState, for cellType: CellType) {
        let newPicture: UIImage?
        switch imageState {
        case .changed(let newImage):
            newPicture = newImage
        default:
            newPicture = nil
        }
        
        self.imageState = imageState
        let _ = updatePersonInformation(cellType, data: newPicture)
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
        if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
            picker.mediaTypes = mediaTypes
        }
        present(self.picker, animated: true, completion: nil)
    }
    
    func runCamera() {
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(self.picker, animated: true, completion: nil)
    }
    
    func showNoteTextView(for cellType: CellType) {
        let destinationController = self.storyboard!.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        destinationController.currentText = currentPersonCopy.notes
        destinationController.callback = {[weak self] text in
            let _ = self?.updatePersonInformation(cellType, data: text)
        }
        present(destinationController, animated: true, completion: nil)
    }
}
