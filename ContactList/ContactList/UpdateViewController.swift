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
    
    @IBOutlet weak var imageAreaTF: UIImageView!    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    
    var imageState: ImageEditState!
    
    var currentPersonForEditing: Person?
    var currentPersonCopy = Person()
    
    var contactListDelegate: ContactListDelegate?
    var callback: ((Person) -> Void)?
    
    var fieldsCheckingIsOk: Bool!
    
    let picker = UIImagePickerController()
    
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        contactListDelegate?.updatePresonInformation(person: currentPersonCopy)
        if let callback = callback {
            callback(currentPersonCopy)
        }
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
        
        currentPersonCopy = currentPersonForEditing!.copy() as! Person
        fillTextFields()
        fieldsCheckingIsOk = allFieldsAreValid() && atLeastOneFieldIsFilled()
        
        picker.delegate = self
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(tapGuestureRecognizer:)))
        imageAreaTF.isUserInteractionEnabled = true
        imageAreaTF.addGestureRecognizer(recognizer)
        
        imageState = .noChanges
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
        imageAreaTF.image = currentPersonCopy.image ?? emptyAvatar
    }
    
    func allFieldsAreValid() -> Bool {
        let firstNameValidationResult = isValidName(text: currentPersonCopy.firstName!)
        firstNameTF.backgroundColor = firstNameValidationResult ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        let lastNameValidationResult = isValidName(text: currentPersonCopy.lastName!)
        lastNameTF.backgroundColor = lastNameValidationResult ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        let phoneNumberValidationResult = isValidPhoneNumber(number: currentPersonCopy.phoneNumber!)
        phoneTF.backgroundColor = phoneNumberValidationResult ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        let emailValidationResult = isValidEmail(email: currentPersonCopy.email!)
        emailTF.backgroundColor = emailValidationResult ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
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
        saveButton.isEnabled = (currentPersonForEditing != currentPersonCopy) && fieldsCheckingIsOk
    }
    
}

extension UpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageAreaTF.contentMode = .scaleAspectFit
        imageAreaTF.image = chosenImage
        currentPersonCopy.image = imageAreaTF.image!
        changeSaveButtonAvailability()
        dismiss(animated:true, completion: nil)
        
        imageState = .changed(newImage: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UpdateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return false
    }
}
