//
//  TableViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var emptyListView: UIView!
    
    @IBAction func addContactButtonOnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForUpdate")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
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
//            tableView.backgroundView = emptyListView
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        
        return personsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let currentPerson = personsArray[indexPath.row]
        var fullName: String = ""
        
        cell.cellImage.image = UIImage(named: currentPerson.imagePath ?? "emptyAvatar")
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
        switch segue.identifier {
        case "showTheContact":
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! ViewControllerForShow
                destinationController.showPersonData(at: indexPath.row)
            }
        case "addContact":
            let destinationController = segue.destination as! ViewControllerForUpdate
            destinationController.delegate = self
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationController.getPersonForUpdate(at: indexPath.row)
            } else {
                destinationController.getPersonForAddition(at: personsArray.count)
            }
        default:
            break
        }
        
    }
}
extension TableViewController: Delegate {
    
    func onRowAddition(newIndex: Int) {
        let indexPath = IndexPath(row: newIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
