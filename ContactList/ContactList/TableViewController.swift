//
//  TableViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    private var searchController: UISearchController!
    private var buttonCopy: UIBarButtonItem?
    private var buttonsCopy: (left: UIBarButtonItem, right: UIBarButtonItem)!
    private let rowsCountForDisplaySearchBar = 5
    private (set) var keysArray = [String]()
    private (set) var groupedPersons: [String : [Person]]! {
        didSet {
            if groupedPersons.isEmpty {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            } else {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
            keysArray = Array(groupedPersons.keys).sorted()
        }
    }    
    
    @IBOutlet private var emptyListView: UIView!
    @IBOutlet private weak var addNewContactButton: UIBarButtonItem!
    @IBOutlet private weak var editTableButton: UIBarButtonItem!
    
    
    @IBAction func addNewContact(_ sender: Any?) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "UpdateController") as! UpdateController
        controller.contactListDelegate = self
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func editTable(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        let doneButton = NSLocalizedString("DONE_BUTTON", comment: "Done")
        let editButton = NSLocalizedString("EDIT_BUTTON", comment: "Edit")
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? doneButton : editButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = emptyListView
        buttonsCopy = (editTableButton, addNewContactButton)
        groupedPersons = DataManager.getDictionary()
        createSearchBar()
        changeSearchBarVisibility()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        changeButtonsVisibility()
        return groupedPersons.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !groupedPersons.isEmpty ? groupedPersons[keysArray[section]]!.count : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForShow") as! ViewControllerForShow
        controller.person = getPerson(at: indexPath)
        controller.contactListDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.updateWith(contact: getPerson(at: indexPath))
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
            self.deletePerson(by: self.getPerson(at: indexPath).id)
        }
        let updateAction = UITableViewRowAction(style: .default, title: editButton) {(action, indexPath) in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "UpdateController") as! UpdateController
            controller.currentPersonForEditing = self.groupedPersons[self.keysArray[indexPath.section]]![indexPath.row]

            controller.contactListDelegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .orange
        return [deleteAction, updateAction]
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.deletePerson(by: getPerson(at: indexPath).id)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysArray
    }
}

extension TableViewController: ContactListDelegate {
    
    func updatePersonInformation(person: Person) {

        let categoryName = person.fullName.first?.uppercased() ?? "~"
        addNewSection(with: categoryName)
        if !updateCurrentPerson(person: person, in: categoryName) {
            appendNewPerson(person: person, in: categoryName)
            changeSearchBarVisibility()
        }
        updateDictionary()
    }
    
    func deletePerson(by id: String) {
        guard let result = getCategoryNameAndIndex(by: id) else {
            return
        }        
        removeCurrentPerson(by: result)
        DataManager.saveImage(by: .removed, name: id)
        updateDictionary()
        changeSearchBarVisibility()
    }
}

private extension TableViewController {
    
    func changeButtonsVisibility() {
        navigationItem.setRightBarButton(!groupedPersons.isEmpty ? buttonsCopy.right : nil, animated: true)
        navigationItem.setLeftBarButton(!groupedPersons.isEmpty ? buttonsCopy.left : nil, animated: true)
    }
    
    func createSearchBar() {
        let searchResultController = self.storyboard!.instantiateViewController(withIdentifier: "SearchResultController") as! SearchResultController
        searchResultController.delegate = self
        searchResultController.getPersonsCallback = {self.getPersonsArrayFromDictionary()}
        searchResultController.pushControllerCallback = {[weak self] controller in self?.navigationController?.pushViewController(controller, animated: true)}
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = searchResultController
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func changeSearchBarVisibility() {
        if getPersonsArrayFromDictionary().count >= rowsCountForDisplaySearchBar {
            tableView.tableHeaderView = searchController.searchBar
        } else if tableView.tableHeaderView != nil {
            tableView.tableHeaderView = nil
        }
    }
    
    func getPersonsArrayFromDictionary() -> [Person] {
        return groupedPersons.values.flatMap{$0}
    }
    
    func getPerson(at indexPath: IndexPath) -> Person {
        return groupedPersons[keysArray[indexPath.section]]![indexPath.row]
    }
    
    func addNewSection(with categoryName: String) {
        if keysArray.firstIndex(of: categoryName) == nil {
            keysArray.append(categoryName)
            keysArray.sort()
            groupedPersons[categoryName] = []
            if let keysArrayIndex = getKeysArrayIndex(by: categoryName) {
                tableView.insertSections(IndexSet(arrayLiteral: keysArrayIndex), with: .automatic)
            }
        }
    }
    
    func updateCurrentPerson(person: Person, in newCategoryName: String) -> Bool {
        guard let result = getCategoryNameAndIndex(by: person.id) else {
            return false
        }
        guard let _ = groupedPersons[newCategoryName] else {return false}
        
        let currentDirectoryName: String
        let currentArrayIndex: Int
        (currentDirectoryName, currentArrayIndex) = result
        
        let personOldVersion = groupedPersons[currentDirectoryName]![currentArrayIndex]
        guard let sectionNumber = getKeysArrayIndex(by: currentDirectoryName) else {return false}
        let indexPath = IndexPath(row: currentArrayIndex, section: sectionNumber)
        
        if Search.isPersonsFullNameFirstCharEqual(firstPerson: personOldVersion, secondPerson: person) {
            groupedPersons[currentDirectoryName]![currentArrayIndex] = person
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            if let targetDirectory = groupedPersons[newCategoryName] {
                guard let keysArrayIndex = getKeysArrayIndex(by: newCategoryName) else {return false}
                let targetIndexPath = IndexPath(row: targetDirectory.count, section: keysArrayIndex)
                groupedPersons[currentDirectoryName]!.remove(at: currentArrayIndex)
                groupedPersons[newCategoryName]?.append(person)
                tableView.moveRow(at: indexPath, to: targetIndexPath)
                tableView.reloadRows(at: [targetIndexPath], with: .automatic)
            }
            if groupedPersons[currentDirectoryName]!.isEmpty {
                removeSection(by: currentDirectoryName)
            }
        }
        return true
    }
    
    func appendNewPerson(person: Person, in categoryName: String) {
        if let targetDirectory = groupedPersons[categoryName] {
            let targetSectionNumber = keysArray.firstIndex(of: categoryName)!
            let targetRow = targetDirectory.count
            let targetIndexPath = IndexPath(row: targetRow, section: targetSectionNumber)
            groupedPersons[categoryName]?.append(person)
            tableView.insertRows(at: [targetIndexPath], with: .automatic)
        }
    }
    
    func removeCurrentPerson(by result: (directoryName: String, arrayIndex: Int)) {
        guard let keysArrayIndex = getKeysArrayIndex(by: result.directoryName) else {return}
        guard let _ = groupedPersons[result.directoryName] else {return}
        
        tableView.beginUpdates()
        groupedPersons[result.directoryName]!.remove(at: result.arrayIndex)
        let indexPath = IndexPath(row: result.arrayIndex, section: keysArrayIndex)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if groupedPersons[result.directoryName]!.isEmpty {
            removeSection(by: result.directoryName)
        }
        tableView.endUpdates()
    }
    
    func getCategoryNameAndIndex(by id: String) -> (String, Int)? {
        for category in groupedPersons {
            if let foundedIndex: Int = category.value.firstIndex(where: {(person) -> Bool in return person.id == id}) {
                return (category.key, foundedIndex)
            }
        }
        return nil
    }
    
    func getKeysArrayIndex(by key: String) -> Int? {
        return keysArray.firstIndex(of: key)
    }
    
    func removeSection(by key: String) {
        guard let keysArrayIndex = getKeysArrayIndex(by: key) else {return}
        guard let guardPersonIndexForRemove = groupedPersons.index(forKey: key) else {return}
        groupedPersons.remove(at: guardPersonIndexForRemove)
        tableView.deleteSections(IndexSet(arrayLiteral: keysArrayIndex), with: .automatic)
    }
    
    func updateDictionary() {
        DataManager.putDictionary(myDictionary: groupedPersons)
    }
}
