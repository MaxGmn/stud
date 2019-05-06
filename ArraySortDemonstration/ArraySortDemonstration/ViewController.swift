//
//  ViewController.swift
//  ArraySortDemonstration
//
//  Created by Maksym Humeniuk on 5/2/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sortTypeSwitcher: UISegmentedControl!
    
    var arrayForSort = [arrayFilling()]
    
    var arrayRebuilding = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextOnAction(_ sender: Any) {
        
        switch sortTypeSwitcher.selectedSegmentIndex{
        case 0:
            let sortingResult = bubbleSort(inputArray: arrayForSort[0])
            exchangeRows(sortingResult.from, sortingResult.to, sortingResult.sortedArray)
        case 1:
            let sortingResult = inputSort(inputArray: arrayForSort[0])
            exchangeRows(sortingResult.from, sortingResult.to, sortingResult.sortedArray)
        case 2:
            mergeSort()
        default:
            break
        }
    }
    
    @IBAction func changeSortType(_ sender: Any) {
        arrayForSort = [arrayFilling()]
        arrayRebuilding = false
        tableView.reloadData()
    }
    
    func exchangeRows(_ from: Int, _ to: Int, _ sortedArray: [Int]){
        arrayForSort[0] = sortedArray
        let fromIndexPath = IndexPath(row: from, section: 0)
        let toIndexPath = IndexPath(row: to, section: 0)
        tableView.moveRow(at: fromIndexPath, to: toIndexPath)
    }
    
    func mergeSort(){
        
        let tempArray = arrayForSort
        arrayForSort.removeAll()
        
        tableView.beginUpdates()
        
        if !arrayRebuilding {            
            for (index, insideArray) in tempArray.enumerated(){
                if insideArray.count == 1 {
                    arrayForSort.append(insideArray)
                    continue
                }

                let middle = insideArray.count / 2
                arrayForSort.append([Int](insideArray[0...middle-1]))
                arrayForSort.append([Int](insideArray[middle...insideArray.count-1]))

                var indexPathArray = [IndexPath]()
                for i in middle..<insideArray.count {
                    indexPathArray.append(IndexPath(row: i, section: index))
                }
                
                tableView.deleteRows(at: indexPathArray, with: .automatic)
                tableView.insertSections(IndexSet(integer: arrayForSort.count-1), with: .automatic)

                arrayRebuilding = arrayForSort.count == 10
            }
            
        } else {
            var tableCounter = 0
            for i in stride(from: 0, to: tempArray.count, by: 2){

                var resultArray = [Int]()
                var leftArray = [Int]()
                
                if i == tempArray.count - 1 {
                    leftArray = tempArray[i-1]
                    resultArray = tempArray[i]
                    
                } else {
                    leftArray = tempArray[i]
                    let rightArray = tempArray[i+1]
                    
                    var x = 0
                    var y = 0
                    
                    
                    while leftArray.count > x && rightArray.count > y{
                        if leftArray[x] <= rightArray[y]{
                            resultArray.append(leftArray[x])
                            x += 1
                        } else {
                            resultArray.append(rightArray[y])
                            y += 1
                        }
                    }
                    
                    if x < leftArray.count{
                        resultArray += leftArray[x...leftArray.count - 1]
                    }
                    
                    if y < rightArray.count{
                        resultArray += rightArray[y...rightArray.count - 1]
                    }
                }
                
                arrayForSort.append(resultArray)
                
                var indexArrayForDelete = [IndexPath]()
                for counter in 0..<leftArray.count {
                    indexArrayForDelete.append(IndexPath(row: counter, section: tableCounter))
                }
                
                tableView.deleteRows(at: indexArrayForDelete, with: .automatic)
                
                var indexArrayForInsertion = [IndexPath]()
                for counter in 0..<resultArray.count {
                    indexArrayForInsertion.append(IndexPath(row: counter, section: tableCounter))
                }
                
                tableView.insertRows(at: indexArrayForInsertion, with: .automatic)
                
                tableCounter += 1
            }
            if tempArray.count > arrayForSort.count {
                tableView.deleteSections(IndexSet(integersIn: arrayForSort.count..<tempArray.count), with: .automatic)
            }
        }
        tableView.endUpdates()
    }
    
}

extension ViewController: UITableViewDataSource{
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayForSort.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForSort[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        currentCell.textLabel?.text = "\(arrayForSort[indexPath.section][indexPath.row])"
        
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let update = UITableViewRowAction(style: .default, title: "Update") {(action, indexPath) in
            let alert = UIAlertController(title: "Всё пропало!", message: "Нифига не работает!", preferredStyle: .alert)            
            let action = UIAlertAction(title: "Ок, понятно", style: .cancel) { (action) in }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        let remove = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            self.arrayForSort[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
        }
        
        remove.backgroundColor = .red
        update.backgroundColor = .green
        
        return [remove, update]
    }
}


