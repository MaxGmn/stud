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
        self.present(navController, animated:true, completion: nil)
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
        if personsArray.isEmpty {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        
        addContactButtonSetVisibility()
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
}

extension TableViewController: ContactListDelegate {
    
    func updatePresonInformation(person: Person) {
        if let index = findItemIndex(by: person.id, in: personsArray) {
            personsArray[index] = person
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            personsArray.append(person)
            let indexPath = IndexPath(row: personsArray.count-1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func deletePerson(by id: UUID) {
        guard let index = findItemIndex(by: id, in: personsArray) else {
            return
        }
        
        personsArray.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
