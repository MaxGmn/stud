//
//  DescriptionViewController.swift
//  TableView
//
//  Created by Maksym Humeniuk on 4/30/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var dataStructureDescription: UILabel!
    
    var descriptionText = ""
    
    func createDescription(at index: Int){
        descriptionText += "Title: " + dataStructures[index].title + "\n\n"
        descriptionText += "Description: " + dataStructures[index].description + "\n\n"
        descriptionText += "Addition: " + dataStructures[index].add + "\n\n"
        descriptionText += "Reading: " + dataStructures[index].read + "\n\n"
        descriptionText += "Remowe: " + dataStructures[index].remowe
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStructureDescription.text = descriptionText
        dataStructureDescription.textAlignment = .natural
        dataStructureDescription.numberOfLines = 0
        dataStructureDescription.sizeToFit()
    }
}
