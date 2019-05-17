//
//  ViewControllerForUpdate.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    
    @IBOutlet private weak var firstNameTF: UITextField!
    @IBOutlet private weak var lastNameTF: UITextField!
    @IBOutlet private weak var phoneTF: UITextField!
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var imageArea: UIImageView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var removeButton: UIBarButtonItem!
    
    private var imageState = ImageEditState.noChanges
    private var currentPersonCopy: Person!
    private var fieldsCheckingIsOk: Bool!
    
    var currentPersonForEditing: Person!
    var contactListDelegate: ContactListDelegate?
    var callback: ((Person) -> Void)?
    let picker = UIImagePickerController()
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        DataManager.saveImage(by: imageState, name: currentPersonCopy.id)
        contactListDelegate?.updatePersonInformation(person: currentPersonCopy)
        callback?(currentPersonCopy)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        contactListDelegate?.deletePerson(by: currentPersonCopy.id)
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func versionComparison(_ sender: Any) {
        changeCurrentPersonCopy()
        fieldsCheckingIsOk = allFieldsAreValid() && atLeastOneFieldIsFilled()
        changeSaveButtonAvailability()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentPersonForEditing == nil {
            currentPersonForEditing = Person()
        }
        currentPersonCopy = (currentPersonForEditing!.copy() as! Person)
        fillTextFields()
        fieldsCheckingIsOk = allFieldsAreValid() && atLeastOneFieldIsFilled()
        addImagePicker()
    }
}

extension UpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        changeCurrentImage(imageState: .changed(newImage: choosenImage))
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UpdateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

private extension UpdateViewController {
    
    func changeCurrentPersonCopy() {
        currentPersonCopy.firstName = firstNameTF.text ?? ""
        currentPersonCopy.lastName = lastNameTF.text ?? ""
        currentPersonCopy.phoneNumber = phoneTF.text ?? ""
        currentPersonCopy.email = emailTF.text ?? ""
    }
    
    func fillTextFields() {
        firstNameTF.text = currentPersonCopy.firstName
        lastNameTF.text = currentPersonCopy.lastName
        phoneTF.text = currentPersonCopy.phoneNumber
        emailTF.text = currentPersonCopy.email
        imageArea.image = currentPersonCopy.image ?? Constants.emptyAvatar
    }
    
    func allFieldsAreValid() -> Bool {
        let firstNameValidationResult = Validation.isValidField(text: currentPersonCopy.firstName, kindOfField: .forTextField(maxLength: 20))
        firstNameTF.backgroundColor = firstNameValidationResult.color
        
        let lastNameValidationResult = Validation.isValidField(text: currentPersonCopy.lastName, kindOfField: .forTextField(maxLength: 20))
        lastNameTF.backgroundColor = lastNameValidationResult.color
        
        let phoneNumberValidationResult = Validation.isValidField(text: currentPersonCopy.phoneNumber, kindOfField: .forPhoneNumber)
        phoneTF.backgroundColor = phoneNumberValidationResult.color
        
        let emailValidationResult = Validation.isValidField(text: currentPersonCopy.email, kindOfField: .forEmail)
        emailTF.backgroundColor = emailValidationResult.color
        
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
    
    func addImagePicker() {
        picker.delegate = self
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(tapGuestureRecognizer:)))
        imageArea.isUserInteractionEnabled = true
        imageArea.addGestureRecognizer(recognizer)
        imageArea.contentMode = .scaleAspectFit
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
            imageArea.image = Constants.emptyAvatar
            currentPersonCopy.image = nil
        case .changed(let newImage):
            imageArea.image = newImage
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
