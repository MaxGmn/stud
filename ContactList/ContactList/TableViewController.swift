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
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
        controller.contactListDelegate = self
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
        personsArray = UserDefaultsWorking.getArray()
    }
    
    func addContactButtonSetVisibility() {
        navigationItem.setRightBarButton(!personsArray.isEmpty ? buttonCopy : nil, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        addContactButtonSetVisibility()
        
        if personsArray.isEmpty {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
            return 0
        }
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundView?.isHidden = true
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personsArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForShow") as! ViewControllerForShow
        controller.person = personsArray[indexPath.row]
        controller.contactListDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.updateWith(contact: personsArray[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.isEditing {
            return nil
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            self.deletePerson(by: self.personsArray[indexPath.row].id)
        }
        
        let updateAction = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath) in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
            controller.currentPersonForEditing = self.personsArray[indexPath.row]
            controller.contactListDelegate = self
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
        self.deletePerson(by: personsArray[indexPath.row].id)
    }
}

extension TableViewController: ContactListDelegate {
    
    func updatePersonInformation(person: Person) {
        if let index = (personsArray.firstIndex {(item) -> Bool in item.id == person.id}) {
            personsArray[index] = person
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.beginUpdates()
            if personsArray.isEmpty {
                tableView.insertSections(IndexSet(arrayLiteral: 0), with: .automatic)
            }            
            personsArray.append(person)
            let indexPath = IndexPath(row: personsArray.count-1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        updatePersonsArray()
    }
    
    func deletePerson(by id: String) {
        guard let index = (personsArray.firstIndex {(item) -> Bool in item.id == id}) else {
            return
        }
        
        tableView.beginUpdates()
        personsArray.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if personsArray.isEmpty {
            tableView.deleteSections(IndexSet(arrayLiteral: 0), with: .automatic)
        }
        tableView.endUpdates()
        
        UserDefaultsWorking.saveImage(by: .removed, name: id)
        updatePersonsArray()
    }
    
    func updatePersonsArray() {
        UserDefaultsWorking.putArray(array: personsArray)
    }
}
