//
//  ViewControllerForUpdate.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewControllerForUpdate: UIViewController {
    
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var imageAreaTF: UIImageView!    
    
    @IBOutlet var forUpdate: UIView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    
    var currentPersonForEditing = Person()
    var currentPersonCopy = Person()
    
    var handler: ContactListHandler?
    var callback: ((Person, Bool) -> Void)?
    
    var changedArrayItemIndex: Int?
    var fieldsCheckingIsOk: Bool!
    
    let picker = UIImagePickerController()
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if let arrayIndex = changedArrayItemIndex {
            handler?.updatePresonInformation(person: currentPersonCopy, at: arrayIndex)
        } else {
            handler?.addNewPerson(person: currentPersonCopy)
        }
        if let callback = callback {
            callback(currentPersonCopy, false)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        guard let arrayIndex = changedArrayItemIndex else {
            return
        }
        
        handler?.deletePerson(at: arrayIndex)
        if let callback = callback {
            callback(currentPersonCopy, true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func versionComparison(_ sender: Any) {
        changeCurrentPersonCopy()
        fieldsCheckingIsOk = allFieldsAreValid() && atLeastOneFieldIsFilled()
        changeSaveButtonAvailability()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPersonCopy = currentPersonForEditing.copy()
        fillTextFields()
        fieldsCheckingIsOk = allFieldsAreValid() && atLeastOneFieldIsFilled()
        if let _ = changedArrayItemIndex {
            removeButton.isEnabled = true
        }
        
        picker.delegate = self
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(tapGuestureRecognizer:)))
        imageAreaTF.isUserInteractionEnabled = true
        imageAreaTF.addGestureRecognizer(recognizer)
    }
    
    @objc func onImageTap (tapGuestureRecognizer: UITapGestureRecognizer) {
        
        if imageAreaTF.image != emptyAvatar {
            let choosePhotoAction = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
            let changeAction = UIAlertAction(title: "Change image", style: .default) {action in self.runCooseImageHandler()}
            let removeAction = UIAlertAction(title: "Remove image", style: .destructive) {action in self.changeCurrentImage(image: emptyAvatar!)}
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            choosePhotoAction.addAction(changeAction)
            choosePhotoAction.addAction(removeAction)
            choosePhotoAction.addAction(cancel)
            present(choosePhotoAction, animated: true, completion: nil)
        } else {
            runCooseImageHandler()
        }
    }
    
    func createNewPerson(){
        currentPersonForEditing = Person()
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
        imageAreaTF.image = currentPersonCopy.image
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
    
    func changeCurrentImage(image: UIImage) {
        imageAreaTF.contentMode = .scaleAspectFit
        imageAreaTF.image = image
        currentPersonCopy.image = imageAreaTF.image!
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

extension ViewControllerForUpdate: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        changeCurrentImage(image: choosenImage)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
