//
//  TableViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var personsArray = [Person]()
    
    @IBOutlet var emptyListView: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
            tableView.backgroundView = emptyListView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if personsArray.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        
        return personsArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForShow") as! ViewControllerForShow
        controller.person = personsArray[indexPath.row]
        controller.currentAttayIndex = indexPath.row
        controller.handler = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let currentPerson = personsArray[indexPath.row]
        
        var fullName: String = ""
        
        cell.cellImage.image = currentPerson.image
        cell.cellContact.text = currentPerson.phoneNumber ?? currentPerson.email
        
        if let firstName = currentPerson.firstName {
            fullName += firstName
        }
        
        if let lastName = currentPerson.lastName {
            fullName += (fullName.isEmpty ? "" : " ") + lastName
        }
        
        cell.cellName.text = fullName
        
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContact" {
            let destinationController = segue.destination as! ViewControllerForUpdate
            destinationController.handler = self
            destinationController.createNewPerson()
        }        
    }
}

extension TableViewController: ContactListHandler {
    
    func addNewPerson(person: Person) {
        personsArray.append(person)
        let indexPath = IndexPath(row: personsArray.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func updatePresonInformation(person: Person, at index: Int) {
        personsArray[index] = person
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
