//
//  TableViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    private (set) var groupedPersons: [String : [Person]]!
    private (set) var keysArray = [String]()
    
    private var searchController: UISearchController!
    
    @IBOutlet private var emptyListView: UIView!
    
    @IBOutlet private weak var addNewContactButton: UIBarButtonItem!
    private var buttonCopy: UIBarButtonItem?
    
    @IBAction func addNewContact(_ sender: Any?) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
        controller.contactListDelegate = self
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func editTable(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        let editButton = NSLocalizedString("EDIT_BUTTON", comment: "Edit")
        let doneButton = NSLocalizedString("DONE_BUTTON", comment: "Done")
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? doneButton : editButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = emptyListView
        buttonCopy = addNewContactButton
        groupedPersons = DataManager.getDictionary()
        createSearchBar()
        changeSearchBarVisibility()
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
        
        let editButton = NSLocalizedString("EDIT_BUTTON", comment: "Edit")
        let deleteButton = NSLocalizedString("DELETE_BUTTON", comment: "Delete")
        
        let deleteAction = UITableViewRowAction(style: .default, title: deleteButton) {(action, indexPath) in
            self.deletePerson(by: self.groupedPersons[self.keysArray[indexPath.section]]![indexPath.row].id)
        }
        let updateAction = UITableViewRowAction(style: .default, title: editButton) {(action, indexPath) in
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
        self.deletePerson(by: groupedPersons[self.keysArray[indexPath.section]]![indexPath.row].id)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysArray
    }
}

extension TableViewController: ContactListDelegate {
    
    func updatePersonInformation(person: Person) {
        tableView.beginUpdates()
        let categoryName = Search.getFullNameString(from: person).first?.uppercased() ?? "~"
        addNewSection(with: categoryName)
        if !updateCurrentPerson(person: person, in: categoryName) {
            appendNewPerson(person: person, in: categoryName)
            changeSearchBarVisibility()
        }
        tableView.endUpdates()
        updateDictionary()
    }
    
    func deletePerson(by id: String) {
        removeCurrentPerson(by: id)
        updateDictionary()
        changeSearchBarVisibility()
    }
}

private extension TableViewController {
    
    private func addContactButtonSetVisibility() {
        navigationItem.setRightBarButton(!groupedPersons.isEmpty ? buttonCopy : nil, animated: true)
    }
    
    private func createSearchBar() {
        let searchResultController = self.storyboard!.instantiateViewController(withIdentifier: "SearchResultController") as! SearchResultController
        searchResultController.mainTableView = self
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = searchResultController
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    private func changeSearchBarVisibility() {
        if Search.getPersonsArrayFromDictionary(from: groupedPersons).count >= 10 {
            tableView.tableHeaderView = searchController.searchBar
        } else {
            tableView.tableHeaderView = nil
        }
    }
    
    private func addNewSection(with categoryName: String) {
        if keysArray.firstIndex(of: categoryName) == nil {
            keysArray.append(categoryName)
            keysArray.sort()
            groupedPersons[categoryName] = []
            tableView.insertSections(IndexSet(arrayLiteral: getKeysArrayIndex(by: categoryName)), with: .automatic)
        }
    }
    
    private func updateCurrentPerson(person: Person, in categoryName: String) -> Bool {
        for dictionaryItem in groupedPersons {
            guard let index = (dictionaryItem.value.firstIndex {(item) -> Bool in item.id == person.id}) else {
                continue
            }
            let personOldVersion = groupedPersons[dictionaryItem.key]![index]
            let sectionNumber = getKeysArrayIndex(by: dictionaryItem.key)
            let indexPath = IndexPath(row: index, section: sectionNumber)
            
            if Search.isPersonsFullNameFirstCharCompare(firstPerson: personOldVersion, secondPerson: person) {
                groupedPersons[dictionaryItem.key]![index] = person
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                if let targetDirectory = groupedPersons[categoryName] {
                    let targetIndexPath = IndexPath(row: targetDirectory.count, section: getKeysArrayIndex(by: categoryName))
                    groupedPersons[dictionaryItem.key]!.remove(at: index)
                    groupedPersons[categoryName]?.append(person)
                    tableView.moveRow(at: indexPath, to: targetIndexPath)
                    tableView.reloadRows(at: [targetIndexPath], with: .automatic)
                    if groupedPersons[dictionaryItem.key]!.isEmpty {
                        removeSection(by: dictionaryItem.key)
                    }
                }
            }
            return true
        }
        return false
    }
    
    private func appendNewPerson(person: Person, in categoryName: String) {
        if let targetDirectory = groupedPersons[categoryName] {
            let targetSectionNumber = keysArray.firstIndex(of: categoryName)!
            let targetRow = targetDirectory.count
            let targetIndexPath = IndexPath(row: targetRow, section: targetSectionNumber)
            groupedPersons[categoryName]?.append(person)
            tableView.insertRows(at: [targetIndexPath], with: .automatic)
        }
    }
    
    private func removeCurrentPerson(by id: String)    {
        for dictionaryItem in groupedPersons {
            guard let index = (dictionaryItem.value.firstIndex {(item) -> Bool in item.id == id}) else {
                continue
            }
            tableView.beginUpdates()
            groupedPersons[dictionaryItem.key]!.remove(at: index)
            let indexPath = IndexPath(row: index, section: getKeysArrayIndex(by: dictionaryItem.key))
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if groupedPersons[dictionaryItem.key]!.isEmpty {
                removeSection(by: dictionaryItem.key)
            }
            tableView.endUpdates()
            DataManager.saveImage(by: .removed, name: id)
            break
        }
    }
    
    private func getKeysArrayIndex(by key: String) -> Int {
        return keysArray.firstIndex(of: key)!
    }
    
    private func removeSection(by key: String) {
        let keysArrayIndex = keysArray.firstIndex(of: key)!
        groupedPersons.remove(at: groupedPersons.index(forKey: key)!)
        keysArray.remove(at: keysArrayIndex)
        tableView.deleteSections(IndexSet(arrayLiteral: keysArrayIndex), with: .automatic)
    }
    
    private func updateDictionary() {
        DataManager.putDictionary(myDictionary: groupedPersons)
    }
}
