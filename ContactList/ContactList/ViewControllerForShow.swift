//
//  ViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewControllerForShow: UIViewController {
    
    
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var imageArea: UIImageView!
    
    var person: Person!    
    var contactListDelegate: ContactListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPersonInformation()
    }    
        
    @IBAction func editOnAction(_ sender: Any) {        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
        controller.currentPersonForEditing = person
        controller.contactListDelegate = contactListDelegate
        controller.callback = { [weak self] person in
            self?.person = person
            self?.showPersonInformation()
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

private extension ViewControllerForShow {
    
    func showPersonInformation() {
        firstNameLabel.text = person.firstName
        lastNameLabel.text = person.lastName
        phoneNumberLabel.text = person.phoneNumber
        emailLabel.text = person.email
        imageArea.image = person.image ?? Constants.emptyAvatar
    }
}

