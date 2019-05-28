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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextField.text = currentText
        addNavigationItemButtons()        
    }
}


private extension NotesViewController {
    
    func addNavigationItemButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(sender:)))
        navigationItem.setLeftBarButton(cancelButton, animated: true)
        navigationItem.setRightBarButton(doneButton, animated: true)
        navigationItem.title = NSLocalizedString("NOTES_TITLE", comment: "Notes")
    }
    
    @objc func cancelAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneAction(sender: UIBarButtonItem) {
        callback?(noteTextField.text)
        navigationController?.popViewController(animated: true)
    }
}
