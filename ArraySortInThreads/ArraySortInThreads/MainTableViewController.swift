//
//  MainTableViewController.swift
//  ArraySortInThreads
//
//  Created by Maksym Humeniuk on 5/30/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    private var sectionsArray = [SortTypes]()
    private var rowsArray = [[String]]()    
    private var inputData = [SortTypes : [BaseArrayType]]()
    private let numberOfIterations = 50
    private var rowsCount: Float = 0
    private var rowsDone: Float = 0
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    @IBAction func startAction(_ sender: Any) {
        rowsDone = 0
        for (sectionNumber, sortType) in sectionsArray.enumerated() {
            guard let arrayTypes = inputData[sortType] else {return}
            for (rowNumber, arrayType) in arrayTypes.enumerated() {
                let resultString = ArrayManager.getResultArraySorting(sortType: sortType, arrayType: arrayType, numberOfIterations)
                rowsArray[sectionNumber][rowNumber] = resultString
                let indexPath = IndexPath(row: rowNumber, section: sectionNumber)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                rowsDone += 1
                progressBar.setProgress(rowsDone/rowsCount, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        inputData = fillDataDictionary()
        createEmptyTable()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsArray[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        cell.textLabel?.text = rowsArray[indexPath.section][indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsArray[section].rawValue
    }
}

private extension MainTableViewController {
    
    func createEmptyTable() {
        sectionsArray = inputData.keys.compactMap({$0})
        for section in sectionsArray {
            let tmpArray = Array(repeating: "in process", count: inputData[section]?.count ?? 0)
            rowsCount += Float(tmpArray.count)
            rowsArray.append(tmpArray)
        }
        progressBar.setProgress(0, animated: true)
    }
    
    func fillDataDictionary() -> [SortTypes : [BaseArrayType]] {
        let dictionary: [SortTypes : [BaseArrayType]] = [.bubble : [.random(itemsCount: 100), .sorted(itemsCount: 100), .backSorted(itemsCount: 100), .partiallySorted(itemsCount: 100),
                                                                    .random(itemsCount: 400), .sorted(itemsCount: 400), .backSorted(itemsCount: 400), .partiallySorted(itemsCount: 400),
                                                                    .random(itemsCount: 800), .sorted(itemsCount: 800), .backSorted(itemsCount: 800), .partiallySorted(itemsCount: 800)],
                                                         .insertion : [.random(itemsCount: 1000), .sorted(itemsCount: 1000), .backSorted(itemsCount: 1000), .partiallySorted(itemsCount: 1000),
                                                                       .random(itemsCount: 4000), .sorted(itemsCount: 4000), .backSorted(itemsCount: 4000), .partiallySorted(itemsCount: 4000),
                                                                       .random(itemsCount: 8000), .sorted(itemsCount: 8000), .backSorted(itemsCount: 8000), .partiallySorted(itemsCount: 8000)],
                                                         .quick : [.random(itemsCount: 1000), .sorted(itemsCount: 1000), .backSorted(itemsCount: 1000), .partiallySorted(itemsCount: 1000),
                                                                   .random(itemsCount: 4000), .sorted(itemsCount: 4000), .backSorted(itemsCount: 4000), .partiallySorted(itemsCount: 4000),
                                                                   .random(itemsCount: 8000), .sorted(itemsCount: 8000), .backSorted(itemsCount: 8000), .partiallySorted(itemsCount: 8000)],
                                                         .merge : [.random(itemsCount: 1000), .sorted(itemsCount: 1000), .backSorted(itemsCount: 1000), .partiallySorted(itemsCount: 1000),
                                                                   .random(itemsCount: 4000), .sorted(itemsCount: 4000), .backSorted(itemsCount: 4000), .partiallySorted(itemsCount: 4000),
                                                                   .random(itemsCount: 8000), .sorted(itemsCount: 8000), .backSorted(itemsCount: 8000), .partiallySorted(itemsCount: 8000)]]
        return dictionary
    }
}
