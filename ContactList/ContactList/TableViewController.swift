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
    
    var groupedPersons: [Character : [Person]]!
    var keysArray = [Character]()
    
    var searchController: UISearchController!
    
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
        groupedPersons = DataManager.getDictionary()
        changeSearchBarVisibility()
    }
    
    func refillPersonsArray() {
        personsArray = Search.getPersonsArrayFromDictionary(from: groupedPersons)
    }
    
    func addContactButtonSetVisibility() {
        navigationItem.setRightBarButton(!groupedPersons.isEmpty ? buttonCopy : nil, animated: true)
    }
    
    func changeSearchBarVisibility() {
//        if personsArray.count >= 10 {
            refillPersonsArray()
            let searchResultController = self.storyboard!.instantiateViewController(withIdentifier: "SearchResultController") as! SearchResultController
            searchResultController.mainTableView = self
            searchController = UISearchController(searchResultsController: searchResultController)
            searchController.searchResultsUpdater = searchResultController
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            tableView.tableHeaderView = searchController.searchBar
//        } else {
//            tableView.tableHeaderView = nil
//        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        addContactButtonSetVisibility()
        if groupedPersons.isEmpty {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
            return 0
        }
        tableView.separatorStyle = .singleLine
        tableView.backgroundView?.isHidden = true
        keysArray = Array(groupedPersons.keys).sorted()
        return groupedPersons.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupedPersons.isEmpty {
            return 0
        }
        return groupedPersons[keysArray[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForShow") as! ViewControllerForShow
        controller.person = groupedPersons[keysArray[indexPath.section]]![indexPath.row]
        controller.contactListDelegate = self
        navigationController?.pushViewController(controller, animated: true)
        changeSearchBarVisibility()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.updateWith(contact: groupedPersons[keysArray[indexPath.section]]![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(keysArray[section])
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.isEditing {
            return nil
        }
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            self.deletePerson(by: self.groupedPersons[self.keysArray[indexPath.section]]![indexPath.row].id)
        }
        let updateAction = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath) in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
            controller.currentPersonForEditing = self.groupedPersons[self.keysArray[indexPath.section]]![indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.deletePerson(by: personsArray[indexPath.row].id)
        changeSearchBarVisibility()
    }
}

extension TableViewController: ContactListDelegate {
    
    func updatePersonInformation(person: Person) {
        tableView.beginUpdates()
        let categoryName = Search.getFullNameString(from: person).first ?? "~"
        addNewSection(with: categoryName)
        if !updateCurrentPerson(person: person, in: categoryName) {
            appendNewPerson(person: person, in: categoryName)
        }
        tableView.endUpdates()
        updateDictionary()
    }
    
    func deletePerson(by id: String) {
        
        for dictionaryItem in groupedPersons {
            guard let index = (dictionaryItem.value.firstIndex {(item) -> Bool in item.id == id}) else {
                continue
            }
            
            tableView.beginUpdates()
            groupedPersons[dictionaryItem.key]!.remove(at: index)
            let keysArrayIndex = keysArray.firstIndex(of: dictionaryItem.key)!
            let indexPath = IndexPath(row: index, section: keysArrayIndex)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if groupedPersons[dictionaryItem.key]!.isEmpty {
                groupedPersons.remove(at: groupedPersons.index(forKey: dictionaryItem.key)!)
                keysArray.remove(at: keysArrayIndex)
                tableView.deleteSections(IndexSet(arrayLiteral: keysArrayIndex), with: .automatic)
            }
            tableView.endUpdates()
            
            DataManager.saveImage(by: .removed, name: id)
            updateDictionary()
            break
        }
    }
    
    private func addNewSection(with categoryName: Character) {
        if keysArray.firstIndex(of: categoryName) == nil {
            keysArray.append(categoryName)
            keysArray.sort()
            groupedPersons[categoryName] = []
            let newCategoryIndex = keysArray.firstIndex(of: categoryName)
            tableView.insertSections(IndexSet(arrayLiteral: newCategoryIndex!), with: .automatic)
        }
    }
    
    private func updateCurrentPerson(person: Person, in categoryName: Character) -> Bool {
        for dictionaryItem in groupedPersons {
            guard let index = (dictionaryItem.value.firstIndex {(item) -> Bool in item.id == person.id}) else {
                continue
            }
            
            let personOldVersion = groupedPersons[dictionaryItem.key]![index]
            let sectionNumber = keysArray.firstIndex(of: dictionaryItem.key)!
            let indexPath = IndexPath(row: index, section: sectionNumber)
            
            if Search.isPersonsFullNameFirstCharCompare(firstPerson: personOldVersion, secondPerson: person) {
                groupedPersons[dictionaryItem.key]![index] = person
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                if let targetDirectory = groupedPersons[categoryName] {
                    let targetSectionNumber = keysArray.firstIndex(of: categoryName)!
                    let targetRow = targetDirectory.count
                    let targetIndexPath = IndexPath(row: targetRow, section: targetSectionNumber)
                    groupedPersons[dictionaryItem.key]!.remove(at: index)
                    groupedPersons[categoryName]?.append(person)
                    tableView.moveRow(at: indexPath, to: targetIndexPath)
                    tableView.reloadRows(at: [targetIndexPath], with: .automatic)
                }
            }
            return true
        }
        return false
    }
    
    private func appendNewPerson(person: Person, in categoryName: Character) {
        if let targetDirectory = groupedPersons[categoryName] {
            let targetSectionNumber = keysArray.firstIndex(of: categoryName)!
            let targetRow = targetDirectory.count
            let targetIndexPath = IndexPath(row: targetRow, section: targetSectionNumber)
            groupedPersons[categoryName]?.append(person)
            tableView.insertRows(at: [targetIndexPath], with: .automatic)
        }
    }
    
    func updateDictionary() {
        DataManager.putDictionary(dictionary: groupedPersons)
    }
}
