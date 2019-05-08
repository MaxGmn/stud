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
    
    
    var currentPersonForEditing = Person()
    var currentPersonCopy = Person()
    
    var handler: ContactListHandler?
    var callback: ((Person) -> Void)?
    
    var changedArrayItemIndex: Int?
    
    let picker = UIImagePickerController()
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if let arrayIndex = changedArrayItemIndex {
            handler?.updatePresonInformation(person: currentPersonCopy, at: arrayIndex)
        } else {
            handler?.addNewPerson(person: currentPersonCopy)
        }
        if let callback = callback {
            callback(currentPersonCopy)
        }
        navigationController?.popViewController(animated: true)
    }    
    
    @IBAction func versionComparison(_ sender: Any?) {
        changeCurrentPersonCopy()
        saveButton.isEnabled = currentPersonForEditing != currentPersonCopy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPersonCopy = currentPersonForEditing.copy()
        fillTextFields()
        
        picker.delegate = self
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(tapGuestureRecognizer:)))
        imageAreaTF.isUserInteractionEnabled = true
        imageAreaTF.addGestureRecognizer(recognizer)
    }
    
    @objc func onImageTap (tapGuestureRecognizer: UITapGestureRecognizer) {
        
//        #if targetEnvironment(simulator)
//            picker.allowsEditing = false
//            picker.sourceType = .photoLibrary
//            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//            present(picker, animated: true, completion: nil)
//        #else
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
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.picker, animated: true, completion: nil)
        }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
            alertController.addAction(galleryAction)
            alertController.addAction(cameraAction)
            alertController.addAction(cancel)
        
            self.present(alertController, animated: true, completion: nil)
//        #endif
    }
    
    func createNewPerson(){
        currentPersonForEditing = Person()
    }
    
    func changeCurrentPersonCopy() {
        currentPersonCopy.firstName = firstNameTF.text
        currentPersonCopy.lastName = lastNameTF.text
        currentPersonCopy.phoneNumber = phoneTF.text
        currentPersonCopy.email = emailTF.text
        currentPersonCopy.image = imageAreaTF.image!
    }
    
    func fillTextFields() {
        firstNameTF.text = currentPersonCopy.firstName
        lastNameTF.text = currentPersonCopy.lastName
        phoneTF.text = currentPersonCopy.phoneNumber
        emailTF.text = currentPersonCopy.email
        imageAreaTF.image = currentPersonCopy.image
    }
    
}

extension ViewControllerForUpdate: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageAreaTF.contentMode = .scaleAspectFit
        imageAreaTF.image = chosenImage
        dismiss(animated:true, completion: nil)
        versionComparison(nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
