//
//  ViewControllerForUpdate.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var imageArea: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    
    var imageState = ImageEditState.noChanges
    
    var currentPersonForEditing: Person!
    var currentPersonCopy: Person!
    
    var contactListDelegate: ContactListDelegate?
    var callback: ((Person) -> Void)?
    
    var fieldsCheckingIsOk: Bool!
    
    let picker = UIImagePickerController()
    
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        WorkWithData.saveImage(by: imageState, name: currentPersonCopy.id)
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
        
        picker.delegate = self
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(tapGuestureRecognizer:)))
        imageArea.isUserInteractionEnabled = true
        imageArea.addGestureRecognizer(recognizer)
        imageArea.contentMode = .scaleAspectFit
    }
    
    @objc func onImageTap (tapGuestureRecognizer: UITapGestureRecognizer) {
        
        if let _ = currentPersonCopy.image {
            let choosePhotoAction = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
            let changeAction = UIAlertAction(title: "Change image", style: .default) {action in self.runCooseImageHandler()}
            let removeAction = UIAlertAction(title: "Remove image", style: .destructive) {action in self.changeCurrentImage(imageState: .removed)}
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            choosePhotoAction.addAction(changeAction)
            choosePhotoAction.addAction(removeAction)
            choosePhotoAction.addAction(cancel)
            present(choosePhotoAction, animated: true, completion: nil)
        } else {
            runCooseImageHandler()
        }
    }
    
    func changeCurrentPersonCopy() {
        currentPersonCopy.firstName = firstNameTF.text
        currentPersonCopy.lastName = lastNameTF.text
        currentPersonCopy.phoneNumber = phoneTF.text
        currentPersonCopy.email = emailTF.text
    }
    
    func fillTextFields() {
        firstNameTF.text = currentPersonCopy.firstName
        lastNameTF.text = currentPersonCopy.lastName
        phoneTF.text = currentPersonCopy.phoneNumber
        emailTF.text = currentPersonCopy.email
        imageArea.image = currentPersonCopy.image ?? Constants.emptyAvatar
    }
    
    func allFieldsAreValid() -> Bool {
        let firstNameValidationResult = Validation.isValidField(text: currentPersonCopy.firstName!, kindOfField: .forTextField(maxLength: 20))
        firstNameTF.backgroundColor = firstNameValidationResult.color
        
        let lastNameValidationResult = Validation.isValidField(text: currentPersonCopy.lastName!, kindOfField: .forTextField(maxLength: 20))
        lastNameTF.backgroundColor = lastNameValidationResult.color
        
        let phoneNumberValidationResult = Validation.isValidField(text: currentPersonCopy.phoneNumber!, kindOfField: .forPhoneNumber)
        phoneTF.backgroundColor = phoneNumberValidationResult.color
        
        let emailValidationResult = Validation.isValidField(text: currentPersonCopy.email!, kindOfField: .forEmail)
        emailTF.backgroundColor = emailValidationResult.color
        
        return firstNameValidationResult && lastNameValidationResult && phoneNumberValidationResult && emailValidationResult
    }
    
    func atLeastOneFieldIsFilled() -> Bool {
        let firstNameIsNotEmpty = !currentPersonCopy.firstName!.isEmpty
        let lastNameIsNotEmpty = !currentPersonCopy.lastName!.isEmpty
        let phoneNumberIsNotEmpty = !currentPersonCopy.phoneNumber!.isEmpty
        let emailIsNotEmpty = !currentPersonCopy.email!.isEmpty
        
        return firstNameIsNotEmpty || lastNameIsNotEmpty || phoneNumberIsNotEmpty || emailIsNotEmpty
    }
    
    func changeSaveButtonAvailability() {
        saveButton.isEnabled = (currentPersonForEditing != currentPersonCopy || imageState != ImageEditState.noChanges) && fieldsCheckingIsOk
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
    
    func runCooseImageHandler() {
        #if targetEnvironment(simulator)
            showPhotoLibrary()
        #else
            let alertController = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
            let galleryAction = UIAlertAction(title: "Gallery", style: .default){action in self.showPhotoLibrary()}
            let cameraAction = UIAlertAction(title: "Camera", style: .default){action in self.runCamera()}
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
