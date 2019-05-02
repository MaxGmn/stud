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
    
    var array = arrayFilling()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        array = arrayFilling()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextOnAction(_ sender: Any) {
        
        let sortingResult = sortTypeSwitcher.selectedSegmentIndex == 0 ? bubbleSort(inputArray: array) : inputSort(inputArray: array)
        
        array = sortingResult.sortedArray
        
        let fromIndexPath = IndexPath(row: sortingResult.from, section: 0)
        let toIndexPath = IndexPath(row: sortingResult.to, section: 0)
        tableView.moveRow(at: fromIndexPath, to: toIndexPath)       
    }    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        currentCell.textLabel?.text = "\(array[indexPath.row])"
        
        return currentCell
    }   
}

extension ViewController: UITableViewDelegate{
    
}

