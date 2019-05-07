//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Maksym Humeniuk on 4/26/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentNumberIntPart = 0
    var currentNumberDecimalPart = 0
    var decimalPartDepth = 0
    
    var result = 0.0
    
    var pointInUse = false
    var error = false
    var isResult = true
    var isNegative = false
    
    var currentFuncType = ArithmeticFunctions.none
    
    var buttons = Dictionary<UIButton, ButtonCheck>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = fillMyButtonsDictionary()
    }
    
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
        
        guard !error || button == buttonAC else {
            return
        }
        
        guard let currentButton = buttons[button] else {
            return
        }
        
        switch currentButton {
        case .clear:
            setVariablesToDefaultValue()
        case .invert:
            if isResult {
                result *= -1
                getResult()
            } else if currentNumberIntPart != 0 || currentNumberDecimalPart != 0 {
                isNegative = !isNegative
                setTextInLabel()
            }
        case .percent:
            let addToDecimalPart = currentNumberIntPart % 100
            currentNumberIntPart /= 100
            currentNumberDecimalPart += addToDecimalPart * Int(pow(10, Double(decimalPartDepth)))
            decimalPartDepth += 2
            pointInUse = currentNumberDecimalPart > 0
            setTextInLabel()
        case .point:
            pointInUse = true
        case .operation(let arFunc):
            doArithmeticFunction(funcType: arFunc)
        case .digit(let number):
            
            if isResult {
                currentNumberIntPart = 0
                currentNumberDecimalPart = 0
                decimalPartDepth = 0
                isNegative = false
                isResult = false
                pointInUse = false
            }
            
            if !pointInUse {
                currentNumberIntPart = currentNumberIntPart * 10 + number
            } else {
                currentNumberDecimalPart = currentNumberDecimalPart * 10 + number
                decimalPartDepth += 1
            }
            setTextInLabel()
        }
    }
    
    func doArithmeticFunction(funcType: ArithmeticFunctions){
        
        let currentNumber = getCurrentNumber()
        
        if !isResult{
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
            case .none:
                result = currentNumber
            }
            
            getResult()
        }
        
        isResult = true
        currentFuncType = funcType
    }
    
    func getResult(){
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            label.text = "\(Int(result))"
        } else {
            label.text = "\(result)"
        }
    }
    
    func setVariablesToDefaultValue(){
        
        currentNumberIntPart = 0
        currentNumberDecimalPart = 0
        decimalPartDepth = 0
        
        result = 0.0
        
        pointInUse = false
        error = false
        isResult = true
        isNegative = false
        
        currentFuncType = .none
        
        setTextInLabel()
    }
    
    func setTextInLabel() {
        var resultText = ""
        
        if pointInUse {
            resultText = "\(getCurrentNumber())"
        } else {
            resultText = isNegative ? "-" : ""
            resultText += String(currentNumberIntPart)
        }
        
        label.text = resultText
    }
    
    func getCurrentNumber() -> Double {
        return (Double(currentNumberIntPart) + Double(currentNumberDecimalPart) / pow(10, Double(decimalPartDepth))) * (isNegative ? -1 : 1)
    }
    
    func fillMyButtonsDictionary() -> Dictionary<UIButton, ButtonCheck> {
        let resultDictionary : [UIButton: ButtonCheck] = [buttonAC: .clear,
                                                          buttonInvert: .invert,
                                                          buttonPercent: .percent,
                                                          buttonDiv: .operation(.division),
                                                          buttonMult: .operation(.multiplication),
                                                          buttonDiff: .operation(.subtraction),
                                                          buttonAdd: .operation(.addition),
                                                          buttonEqual: .operation(.none),
                                                          buttonPoint: .point,
                                                          buttonZero: .digit(0),
                                                          buttonOne: .digit(1),
                                                          buttonTwo: .digit(2),
                                                          buttonThree: .digit(3),
                                                          buttonFour: .digit(4),
                                                          buttonFive: .digit(5),
                                                          buttonSix: .digit(6),
                                                          buttonSeven: .digit(7),
                                                          buttonEight: .digit(8),
                                                          buttonNine: .digit(9)]
        return resultDictionary
    }
    
}

enum ButtonCheck {
    case operation(ArithmeticFunctions)
    case digit(Int)
    case clear
    case invert
    case percent
    case point
}

enum ArithmeticFunctions{
    case none
    case addition
    case subtraction
    case multiplication
    case division
}
