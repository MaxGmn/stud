//
//  TableViewController.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/6/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet var mainTable: UITableView!
    
    @IBOutlet var emptyListView: UIView!
    
    
    
    
    
  
    @IBAction func addContactButtonOnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerForUpdate")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if personsArray.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
            tableView.backgroundView = emptyListView
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        
        return personsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentPerson = personsArray[indexPath.row]

        cell.textLabel?.text = currentPerson.firstName + " " + currentPerson.firstName

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTheContact":
            if let indexPath = mainTable.indexPathForSelectedRow{
                let destinationController = segue.destination as! ViewControllerForShow
                destinationController.showPersonData(at: indexPath.row)
            }
        case "addContact":
//            if let indexPath = mainTable.indexPathForSelectedRow{
//                let destinationController = segue.destination as! ViewControllerForUpdate
//                destinationController.showPersonData(at: indexPath.row)
//            }
            break
        default:
            break
        }
        
    }
 

}
