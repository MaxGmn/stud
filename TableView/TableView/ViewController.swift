//
//  ViewController.swift
//  TableView
//
//  Created by Maksym Humeniuk on 4/30/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainTable: UITableView!
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDescription"{
            if let indexRow = mainTable.indexPathForSelectedRow {
                let destinationController = segue.destination as! DescriptionViewController
                destinationController.createDescription(at: indexRow.row)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStructures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)        
        currentCell.textLabel?.text = dataStructures[indexPath.row].title
        
        return currentCell
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

