//
//  MainViewController.swift
//  ArraySortInThreads
//
//  Created by Maksym Humeniuk on 5/31/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private var sectionsArray = [SortTypes]()
    private var rowsArray = [[String]]()
    private var inputData = [SortTypes : [BaseArrayType]]()
    private let numberOfIterations = 50
    private var rowsCount: Float = 0
    private var rowsDone: Float = 0
    private let operationQueue = OperationQueue()
    
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBAction func startAction(_ sender: Any) {
        for (sectionNumber, sortType) in sectionsArray.enumerated() {
            guard let arrayTypes = inputData[sortType] else {return}
            for (rowNumber, arrayType) in arrayTypes.enumerated() {
                operationQueue.addOperation {
                    let resultString = ArrayManager.getResultArraySorting(sortType: sortType, arrayType: arrayType, self.numberOfIterations)
                    self.rowsArray[sectionNumber][rowNumber] = resultString
                    let indexPath = IndexPath(row: rowNumber, section: sectionNumber)
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        self.rowsDone += 1
                        self.progressBar.setProgress(self.rowsDone/self.rowsCount, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        operationQueue.cancelAllOperations()
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputData = fillDataDictionary()
        createEmptyTable()
        operationQueue.qualityOfService = .utility
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        cell.textLabel?.text = rowsArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsArray[section].rawValue
    }
}

private extension MainViewController {
    
    func createEmptyTable() {
        sectionsArray = inputData.keys.compactMap({$0})
        for section in sectionsArray {
            let tmpArray = Array(repeating: "no data", count: inputData[section]?.count ?? 0)
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
