//
//  SearchResultController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/15/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class SearchResultController: UITableViewController {
    
    @IBOutlet weak var emptySearchResultView: UIView!
    
    var mainTableView: TableViewController!
    
    private var personsArray: [Person]!
    private var filteredPersons = [Person]() {
        didSet {
            if filteredPersons.isEmpty {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            } else {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
        }
    }
        
    private var resultStringsArray = [NSAttributedString]()
    private var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = emptySearchResultView
        self.personsArray = Search.getPersonsArrayFromDictionary(from: mainTableView.groupedPersons)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPersons.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForShow") as! ViewControllerForShow
        controller.person = filteredPersons[indexPath.row]
        controller.contactListDelegate = mainTableView
        controller.searchCallback = {[weak self] (previousPerson, currentPerson) in
            guard let previous = previousPerson else {return}
            guard let updateIndex = self?.personsArray.firstIndex(of: previous) else{return}
            self?.personsArray![updateIndex] = currentPerson
            self?.tableView.reloadData()
        }
        mainTableView.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.attributedText = resultStringsArray[indexPath.row]
        return cell
    }
}

extension SearchResultController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        (filteredPersons, resultStringsArray) = Search.getFilterResults(from: personsArray, by: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

