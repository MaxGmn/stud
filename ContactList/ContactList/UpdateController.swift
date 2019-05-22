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
    private var rowsCount: Int!
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
        
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchTableViewCell")
        
        picker.delegate = self
        
        if currentPersonForEditing == nil {
            currentPersonForEditing = Person()
        }
        currentPersonCopy = (currentPersonForEditing!.copy() as! Person)
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
        if indexPath.row == 0 {
            changeImage(for: indexPath)
        }
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
            cell.setContent(cells[indexPath.row])
            return cell
            
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
            setCellData(newImage: nil, at: indexPath.row)
            currentPersonCopy.image = nil
        case .changed(let newImage):
            setCellData(newImage: newImage, at: indexPath.row)
            currentPersonCopy.image = newImage
        default:
            break
        }
        
        self.imageState = imageState
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//        changeSaveButtonAvailability()
    }
    
    func setCellData(newImage: UIImage?, at index: Int) {
        switch cells[index] {
        case .image(var presentation):
            presentation.updateDataType(with: .image(newImage))
            cells[index] = .image(presentation)
        default:
            break
        }
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
