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
    var pointInUse = false
    var currentfuncType = ArithmeticFunctions.none
    var error = false
    var isResult = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var textField: UILabel!
    
    @IBAction func buttonsOnAction(_ sender: Any) {
        let button = sender as! UIButton
        
        if error && button.restorationIdentifier != "buttonAC"{
            return
        }
        
        switch button.restorationIdentifier {
        case "buttonAC":
            result = 0.0
            textField.text = "0"
            pointInUse = false
            currentfuncType = ArithmeticFunctions.none
            error = false
            isResult = true
            
        case "buttonInvert":
            if textField.text != "0" {
                if textField.text!.hasPrefix("-"){
                    textField.text?.removeFirst()
                } else {
                    textField.text = "-" + textField.text!
                }
            }
            
        case "buttonPoint":
            if !pointInUse {
                textField.text = textField.text! + "."
                pointInUse = true
            }
            
        case "buttonPercent":
            textField.text = "\(Double(textField.text!)! / 100)"
        case "buttonDiv":
            doArithmeticFunction(funcType: ArithmeticFunctions.division)
        case "buttonMult":
            doArithmeticFunction(funcType: ArithmeticFunctions.multiplication)
        case "buttonDiff":
            doArithmeticFunction(funcType: ArithmeticFunctions.subtraction)
        case "buttonAdd":
            doArithmeticFunction(funcType: ArithmeticFunctions.addition)
        case "buttonEqual":
            doArithmeticFunction(funcType: ArithmeticFunctions.none)
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
        if isResult { textField.text = "0" }
        textField.text = textField.text == "0" ? number : textField.text! + number
        isResult = false
    }
    
    func doArithmeticFunction(funcType: ArithmeticFunctions){
        
        let currentNumber = Double(textField.text!)!
        
        if currentfuncType == ArithmeticFunctions.none {
            result = currentNumber
            
        } else if !isResult{
            switch currentfuncType {
            case .addition:
                result += currentNumber
            case .subtraction:
                result -= currentNumber
            case .multiplication:
                result *= currentNumber
            case .division:
                if currentNumber == 0.0{
                    textField.text = "ERROR"
                    error = true
                    return
                } else {
                    result /= currentNumber
                }
            default:
                break
            }
            
            getReasult()
        }
        
        isResult = true
        currentfuncType = funcType
    }
    
    func getReasult(){
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            textField.text = "\(Int(result))"
        } else {
            textField.text = "\(result)"
        }
        
        currentfuncType = ArithmeticFunctions.none
    }   
}

enum ArithmeticFunctions{
    case none
    case addition
    case subtraction
    case multiplication
    case division
}
