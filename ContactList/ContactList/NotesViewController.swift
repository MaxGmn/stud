//
//  NotesViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/20/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet private weak var noteTextField: UITextView!
    
    var currentText = ""
    var callback:((String) -> Void)?
    
    
    @IBAction func saveChangesAction(_ sender: Any) {
        callback?(noteTextField.text)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextField.text = currentText 
    }


}
