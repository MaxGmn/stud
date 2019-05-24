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
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var driverLicenseLabel: UILabel!
    @IBOutlet private weak var notesLabel: UILabel!
    
    var person: Person!    
    var contactListDelegate: ContactListDelegate?
    var searchCallback: ((Person?, Person) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPersonInformation()
    }    
        
    @IBAction func editOnAction(_ sender: Any) {        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "UpdateController") as! UpdateController
        controller.currentPersonForEditing = person
        controller.contactListDelegate = contactListDelegate
        controller.callback = { [weak self] person in
            self?.searchCallback?(self?.person, person)
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
        birthdayLabel.text = person.birthday != nil ? Constants.dateFormat.string(from: person.birthday!) : ""
        heightLabel.text = String(person.height)
        driverLicenseLabel.text = person.driverLicense
        notesLabel.text = person.notes
        notesLabel.sizeToFit()
    }
}

