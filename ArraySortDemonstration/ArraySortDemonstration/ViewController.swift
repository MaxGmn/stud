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
        
        if !arrayRebuilding {
            for insideArray in tempArray{
                if insideArray.count == 1 {
                    arrayForSort.append(insideArray)
                    continue
                }
                let middle = insideArray.count / 2
                arrayForSort.append([Int](insideArray[0...middle-1]))
                arrayForSort.append([Int](insideArray[middle...insideArray.count-1]))
                
                arrayRebuilding = arrayForSort.count == 10
            }
            
        } else {
            for i in stride(from: 0, to: tempArray.count, by: 2){
                
                if i == tempArray.count - 1 {
                    arrayForSort.append(tempArray[i])
                    continue
                }
                
                let leftArray = tempArray[i]
                let rightArray = tempArray[i+1]
                
                var i = 0
                var j = 0
                var resultArray = [Int]()
                
                while leftArray.count > i && rightArray.count > j{
                    if leftArray[i] <= rightArray[j]{
                        resultArray.append(leftArray[i])
                        i += 1
                    } else {
                        resultArray.append(rightArray[j])
                        j += 1
                    }
                }
                
                if i < leftArray.count{
                    resultArray += leftArray[i...leftArray.count - 1]
                }
                
                if j < rightArray.count{
                    resultArray += rightArray[j...rightArray.count - 1]
                }
                
                arrayForSort.append(resultArray)
            }
        }
        
        tableView.reloadData()
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
    
    
}

extension ViewController: UITableViewDelegate{
    
}

