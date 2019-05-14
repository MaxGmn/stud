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
    }
    
    @objc func onImageTap (tapGuestureRecognizer: UITapGestureRecognizer) {
        
        #if targetEnvironment(simulator)
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(picker, animated: true, completion: nil)
        #else
            let alertController = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
            let galleryAction = UIAlertAction(title: "Gallery", style: .default){action in
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.picker, animated: true, completion: nil)
            }
            let cameraAction = UIAlertAction(title: "Camera", style: .default){action in
                self.picker.allowsEditing = false
                self.picker.sourceType = .camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
        }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
            alertController.addAction(galleryAction)
            alertController.addAction(cameraAction)
            alertController.addAction(cancel)
        
            self.present(alertController, animated: true, completion: nil)
        #endif
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
    
}

extension UpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageArea.contentMode = .scaleAspectFit
        imageArea.image = chosenImage
        currentPersonCopy.image = imageArea.image!
        imageState = .changed(newImage: chosenImage)
        changeSaveButtonAvailability()
        dismiss(animated:true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UpdateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        view.endEditing(true)
        return false
    }
}
