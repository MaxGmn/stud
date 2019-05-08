//
//  ViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewControllerForShow: UIViewController {
    
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var imageArea: UIImageView!
    
    var person: Person!
    
    var currentAttayIndex: Int!
    
    var handler: ContactListHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPersonInformation()
    }
    
    
    @IBAction func cancelOnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editOnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForUpdate") as! ViewControllerForUpdate
        controller.currentPersonForEditing = person
        controller.changedArrayItemIndex = currentAttayIndex
        controller.handler = handler
        controller.callback = { [weak self] person in
            self?.person = person
            self?.showPersonInformation()
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showPersonInformation() {
        firstName.text = person.firstName
        lastName.text = person.lastName
        phoneNumber.text = person.phoneNumber
        email.text = person.email
        imageArea.image = person.image
    }
    
    
}

