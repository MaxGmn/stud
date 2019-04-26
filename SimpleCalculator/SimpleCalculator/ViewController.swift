//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Maksym Humeniuk on 4/26/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var result = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var textField: UILabel!
    
    @IBAction func buttonsOnAction(_ sender: Any) {
        let button = sender as! UIButton
        
        switch button.restorationIdentifier {
        case "buttonAC":
            result = 0.0
            textField.text = "0"
        case "buttonInvert":
            print("+/-")
        case "buttonPercent":
            print("%")
        case "buttonDiv":
            print("/")
        case "buttonMult":
            print("*")
        case "buttonDiff":
            print("-")
        case "buttonAdd":
            print("+")
        case "buttonEqual":
            print("=")
        case "button0":
            changeTextFieldContent("0")
        case "button1":
            changeTextFieldContent("1")
        case "button2":
            changeTextFieldContent("2")
        case "button3":
            changeTextFieldContent("3")
        case "button4":
            changeTextFieldContent("4")
        case "button5":
            changeTextFieldContent("5")
        case "button6":
            changeTextFieldContent("6")
        case "button7":
            changeTextFieldContent("7")
        case "button8":
            changeTextFieldContent("8")
        case "button9":
            changeTextFieldContent("9")
        default:
            print("Undefined")
        }
    }
    
    func changeTextFieldContent(_ number: String){
        textField.text = textField.text == "0" ? number : textField.text! + number
    }
    
    
    


}

