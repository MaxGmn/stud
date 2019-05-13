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
    
    @IBOutlet weak var addNewContactButton: UIBarButtonItem!
    var buttonCopy: UIBarButtonItem?
    
    @IBAction func addNewContact(_ sender: Any?) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ViewControllerForUpdate") as! ViewControllerForUpdate
        controller.handler = self
        controller.createNewPerson()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func editTable(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = emptyListView
        buttonCopy = addNewContactButton
    }
    
    func addContactButtonSetVisibility() {
        navigationItem.setRightBarButton(!personsArray.isEmpty ? buttonCopy : nil, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if personsArray.isEmpty {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        
        addContactButtonSetVisibility()
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
        
        cell.cellImage.image = currentPerson.image
        cell.cellName.text = currentPerson.firstName! + (currentPerson.firstName!.isEmpty ? "" : " ") + currentPerson.lastName!
        cell.cellContact.text = !currentPerson.phoneNumber!.isEmpty ? currentPerson.phoneNumber : currentPerson.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.isEditing {
            return nil
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            self.deletePerson(at: indexPath.row)
        }
        
        let updateAction = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath) in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerForUpdate") as! ViewControllerForUpdate
            controller.currentPersonForEditing = self.personsArray[indexPath.row]
            controller.changedArrayItemIndex = indexPath.row
            controller.handler = self
            let navController = UINavigationController(rootViewController: controller)
            self.present(navController, animated: true, completion: nil)
        }
        
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .orange
        
        return [deleteAction, updateAction]
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
        
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        personsArray.insert(personsArray.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.deletePerson(at: indexPath.row)
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
    
    func deletePerson(at index: Int) {
        personsArray.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
