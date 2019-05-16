//
//  SearchResultController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/15/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class SearchResultController: UITableViewController {
    
    @IBOutlet weak var searchResultLabel: UILabel!
    
    var mainTableView: TableViewController!
    var personsArray: [Person]!
    var filteredPersons = [Person]()
    var resultStringsArray = [NSAttributedString]()
    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.personsArray = mainTableView.personsArray
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPersons.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForShow") as! ViewControllerForShow
        controller.person = filteredPersons[indexPath.row]
        controller.contactListDelegate = mainTableView
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
