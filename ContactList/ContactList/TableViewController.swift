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
    private var buttonCopy: UIBarButtonItem?
    private var buttonsCopy: (left: UIBarButtonItem, right: UIBarButtonItem)!
    private let rowsCountForDisplaySearchBar = 10
    
    @IBOutlet private var emptyListView: UIView!
    @IBOutlet private weak var addNewContactButton: UIBarButtonItem!
    @IBOutlet private weak var editTableButton: UIBarButtonItem!
    
    
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
//        buttonCopy = addNewContactButton
        buttonsCopy = (editTableButton, addNewContactButton)
        groupedPersons = DataManager.getDictionary()
        createSearchBar()
        changeSearchBarVisibility()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        changeButtonsVisibility()
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
                
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            self.deletePerson(by: self.getPerson(at: indexPath).id)
        }
        let updateAction = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath) in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
            controller.currentPersonForEditing = self.getPerson(at: indexPath)
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
        self.deletePerson(by: getPerson(at: indexPath).id)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysArray
    }
}

extension TableViewController: ContactListDelegate {
    
    func updatePersonInformation(person: Person) {
        tableView.beginUpdates()
        let categoryName = person.fullName.first?.uppercased() ?? "~"
        addNewSection(with: categoryName)
        if !updateCurrentPerson(person: person, in: categoryName) {
            appendNewPerson(person: person, in: categoryName)
            changeSearchBarVisibility()
        }
        tableView.endUpdates()
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
        searchResultController.mainTableView = self
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = searchResultController
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func changeSearchBarVisibility() {
        if Search.getPersonsArrayFromDictionary(from: groupedPersons).count >= rowsCountForDisplaySearchBar {
            tableView.tableHeaderView = searchController.searchBar
        } else {
            tableView.tableHeaderView = nil
        }
    }
    
    func getPerson(at indexPath: IndexPath) -> Person {
        return groupedPersons[keysArray[indexPath.section]]![indexPath.row]
    }
    
    func addNewSection(with categoryName: String) {
        if keysArray.firstIndex(of: categoryName) == nil {
            keysArray.append(categoryName)
            keysArray.sort()
            groupedPersons[categoryName] = []
            tableView.insertSections(IndexSet(arrayLiteral: getKeysArrayIndex(by: categoryName)), with: .automatic)
        }
    }
    
    func updateCurrentPerson(person: Person, in newCategoryName: String) -> Bool {
        guard let result = getCategoryNameAndIndex(by: person.id) else {
            return false
        }
        
        let currentDirectoryName: String
        let currentArrayIndex: Int
        (currentDirectoryName, currentArrayIndex) = result
        
        let personOldVersion = groupedPersons[currentDirectoryName]![currentArrayIndex]
        let sectionNumber = getKeysArrayIndex(by: currentDirectoryName)
        let indexPath = IndexPath(row: currentArrayIndex, section: sectionNumber)
        
        if Search.isPersonsFullNameFirstCharCompare(firstPerson: personOldVersion, secondPerson: person) {
            groupedPersons[currentDirectoryName]![currentArrayIndex] = person
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            if let targetDirectory = groupedPersons[newCategoryName] {
                let targetIndexPath = IndexPath(row: targetDirectory.count, section: getKeysArrayIndex(by: newCategoryName))
                groupedPersons[currentDirectoryName]!.remove(at: currentArrayIndex)
                groupedPersons[newCategoryName]?.append(person)
                tableView.moveRow(at: indexPath, to: targetIndexPath)
                tableView.reloadRows(at: [targetIndexPath], with: .automatic)
                if groupedPersons[currentDirectoryName]!.isEmpty {
                    removeSection(by: currentDirectoryName)
                }
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
    
    func removeCurrentPerson(by result: (directoryName: String, arrayIndex: Int))    {
            tableView.beginUpdates()
            groupedPersons[result.directoryName]!.remove(at: result.arrayIndex)
            let indexPath = IndexPath(row: result.arrayIndex, section: getKeysArrayIndex(by: result.directoryName))
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
    
    func getKeysArrayIndex(by key: String) -> Int {
        return keysArray.firstIndex(of: key)!
    }
    
    func removeSection(by key: String) {
        let keysArrayIndex = keysArray.firstIndex(of: key)!
        groupedPersons.remove(at: groupedPersons.index(forKey: key)!)
        keysArray.remove(at: keysArrayIndex)
        tableView.deleteSections(IndexSet(arrayLiteral: keysArrayIndex), with: .automatic)
    }
    
    func updateDictionary() {
        DataManager.putDictionary(myDictionary: groupedPersons)
    }
}
