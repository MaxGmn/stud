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
    var currentFuncType = ArithmeticFunctions.none
    var error = false
    var isResult = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    //[OL]: I'd recommend to store operand in separate variable and not take it from label
    //Label is just a view to display operand value
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var buttonAC: UIButton!
    
    @IBOutlet weak var buttonInvert: UIButton!
    
    @IBOutlet weak var buttonPercent: UIButton!
    
    @IBOutlet weak var buttonDiv: UIButton!
    
    @IBOutlet weak var buttonMult: UIButton!
    
    @IBOutlet weak var buttonDiff: UIButton!
    
    @IBOutlet weak var buttonAdd: UIButton!
    
    @IBOutlet weak var buttonEqual: UIButton!
    
    @IBOutlet weak var buttonPoint: UIButton!
    
    @IBOutlet weak var buttonZero: UIButton!
    
    @IBOutlet weak var buttonOne: UIButton!
    
    @IBOutlet weak var buttonTwo: UIButton!
    
    @IBOutlet weak var buttonThree: UIButton!
    
    @IBOutlet weak var buttonFour: UIButton!
    
    @IBOutlet weak var buttonFive: UIButton!
    
    @IBOutlet weak var buttonSix: UIButton!
    
    @IBOutlet weak var buttonSeven: UIButton!
    
    @IBOutlet weak var buttonEight: UIButton!
    
    @IBOutlet weak var buttonNine: UIButton!
    
    
    @IBAction func buttonsOnAction(_ sender: Any) {
        let button = sender as! UIButton
        
        //[OL]: Better use `guard`
        if error && button != buttonAC{
            return
        }
        
        switch button {
        case buttonAC:
            result = 0.0
            label.text = "0"
            pointInUse = false
            //[OL]: You may skip ArithmeticFunctions as type is easy to follow by compiler
            currentFuncType = ArithmeticFunctions.none
            error = false
            isResult = true
            
        case buttonInvert:
            if label.text != "0" {
                if label.text!.hasPrefix("-"){
                    label.text?.removeFirst()
                } else {
                    label.text = "-" + label.text!
                }
            }
            
        case buttonPoint:
            if !pointInUse {
                label.text = label.text! + "."
                pointInUse = true
            }
            
        case buttonPercent:
            label.text = "\(Double(label.text!)! / 100)"
        case buttonDiv:
            //[OL]: You may skip ArithmeticFunctions as type is easy to follow by compiler
            //And below
            
            //Copy-paste is bad :)
            //I'd suggest to refactor code as follows:
            //enum ButtonCheck {
            //  case operation(ArithmeticFunctions)
            //  case digit(Int)
            //  case other //may be different cases for other types
            //}
            //
            // func checkButton(_ button: UIButton) -> ButtonCheck {
            //  ...
            //}
            //
            
            doArithmeticFunction(funcType: ArithmeticFunctions.division)
        case buttonMult:
            doArithmeticFunction(funcType: ArithmeticFunctions.multiplication)
        case buttonDiff:
            doArithmeticFunction(funcType: ArithmeticFunctions.subtraction)
        case buttonAdd:
            doArithmeticFunction(funcType: ArithmeticFunctions.addition)
        case buttonEqual:
            doArithmeticFunction(funcType: ArithmeticFunctions.none)
        case buttonZero:
            changeTextFieldContent("0")
        case buttonOne:
            changeTextFieldContent("1")
        case buttonTwo:
            changeTextFieldContent("2")
        case buttonThree:
            changeTextFieldContent("3")
        case buttonFour:
            changeTextFieldContent("4")
        case buttonFive:
            changeTextFieldContent("5")
        case buttonSix:
            changeTextFieldContent("6")
        case buttonSeven:
            changeTextFieldContent("7")
        case buttonEight:
            changeTextFieldContent("8")
        case buttonNine:
            changeTextFieldContent("9")
        default:
            print("Undefined")
        }
    }
    
    func changeTextFieldContent(_ number: String){
        if isResult { label.text = "0" }
        label.text = label.text == "0" ? number : label.text! + number
        isResult = false
    }
    
    func doArithmeticFunction(funcType: ArithmeticFunctions){
        
        let currentNumber = Double(label.text!)!
        
        if currentFuncType == ArithmeticFunctions.none {
            result = currentNumber
            
        } else if !isResult{
            switch currentFuncType {
            case .addition:
                result += currentNumber
            case .subtraction:
                result -= currentNumber
            case .multiplication:
                result *= currentNumber
            case .division:
                if currentNumber == 0.0{
                    label.text = "ERROR"
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
        currentFuncType = funcType
    }
    
    //[OL]: typo
    func getReasult(){
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            label.text = "\(Int(result))"
        } else {
            label.text = "\(result)"
        }
        
        currentFuncType = ArithmeticFunctions.none
    }   
}

enum ArithmeticFunctions{
    case none
    case addition
    case subtraction
    case multiplication
    case division
}
