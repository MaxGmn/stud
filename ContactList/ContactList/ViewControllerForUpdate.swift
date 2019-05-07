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
    
    
    var delegate: Delegate?
    
    var currentIndex = 0
    var currentPersonForEditing = Person()
    
    var currentPersonCopy = Person()
    
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        personsArray.insert(currentPersonCopy, at: currentIndex)
        delegate?.onRowAddition(newIndex: currentIndex)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func versionComparison(_ sender: Any) {
        changeCurrentPersonCopy()
        saveButton.isEnabled = currentPersonForEditing != currentPersonCopy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPersonCopy = currentPersonForEditing.copy()
    }
    
    func getPersonForUpdate(at index: Int) {
        currentIndex = index
        currentPersonForEditing = personsArray[currentIndex]
    }
    
    func getPersonForAddition(at index: Int) {
        currentIndex = index
        currentPersonForEditing = Person()
    }
    
    func changeCurrentPersonCopy() {
        currentPersonCopy.firstName = firstNameTF.text!.isEmpty ? nil : firstNameTF.text
        currentPersonCopy.lastName = lastNameTF.text!.isEmpty ? nil : lastNameTF.text
        currentPersonCopy.phoneNumber = phoneTF.text!.isEmpty ? nil : phoneTF.text
        currentPersonCopy.email = emailTF.text!.isEmpty ? nil : emailTF.text
//        currentPersonCopy.imagePath =
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
