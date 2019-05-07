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
    

    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.text = person.firstName
        lastName.text = person.lastName
        phoneNumber.text = person.phoneNumber
        email.text = person.email
        imageArea.image = UIImage(named: person.imagePath ?? "emptyAvatar")
    }
    
    func showPersonData(at index: Int){
        person = personsArray[index]
    }


}

