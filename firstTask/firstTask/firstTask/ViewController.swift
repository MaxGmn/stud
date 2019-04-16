//
//  ViewController.swift
//  firstTask
//
//  Created by Maksym Humeniuk on 4/16/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//



import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(arithmeticMean(10,20,0));
        print(geometricMean(1,2,4));
        
        //        do{
        //            if let result = try quadratic(a: 10, b: 3, c: 5){
        //                print(result);
        //            }
        //        } catch QuadraticErrors.associatedValue(let D){
        //            print("Associated Value D = \(D)");
        //        }
        
        
        
    }
    
    func arithmeticMean(_ numbers: Double...) -> Double {
        var res = 0.0;
        for number in numbers {
            res += number;
        }
        return res / Double(numbers.count);
    }
    
    
    
    
    func geometricMean(_ numbers: Double...) -> Double {
        var res = numbers[0];
        for i in 1..<numbers.count {
            res *= numbers[i];
        }
        return pow(res, 1/Double(numbers.count));
    }
    
    
    
    
    func quadratic(a:Double, b:Double, c:Double) throws -> (Double,Double)?{
        if a == 0{
            return nil;
        }
        
        let D = pow(b, 2) - 4*a*c;
        
        if D < 0 {
            throw QuadraticErrors.associatedValue(discriminant: D);
        } else if D == 0{
            let x = (-b - sqrt(D)) / 2*a;
            return (x, x);
        } else{
            let x1 = (-b - sqrt(D)) / 2*a;
            let x2 = (-b + sqrt(D)) / 2*a;
            return (x1, x2);
        }
    }
    
    enum QuadraticErrors: Error {
        case associatedValue(discriminant:Double)
    }
    
    
    
    struct ComplexNumber {
        var realPart = 0.0;
        var imaginaryPart = 0.0;
    }
    
    func addComplexNumbers(firstNumber: ComplexNumber, secondNumber: ComplexNumber) -> ComplexNumber{
        var resultNumber = ComplexNumber();
        resultNumber.realPart = firstNumber.realPart + secondNumber.realPart;
        resultNumber.imaginaryPart = firstNumber.imaginaryPart + secondNumber.imaginaryPart;
        return resultNumber;
    }
    
    func diffComplexNumbers(firstNumber: ComplexNumber, secondNumber: ComplexNumber) -> ComplexNumber{
        var resultNumber = ComplexNumber();
        resultNumber.realPart = firstNumber.realPart - secondNumber.realPart;
        resultNumber.imaginaryPart = firstNumber.imaginaryPart - secondNumber.imaginaryPart;
        return resultNumber;
    }
    
    func multComplexNumbers(firstNumber: ComplexNumber, secondNumber: ComplexNumber) -> ComplexNumber{
        var resultNumber = ComplexNumber();
        resultNumber.realPart = firstNumber.realPart * secondNumber.realPart - firstNumber.imaginaryPart * secondNumber.imaginaryPart;
        resultNumber.imaginaryPart = firstNumber.imaginaryPart * secondNumber.realPart + firstNumber.realPart * secondNumber.imaginaryPart;
        return resultNumber;
    }
    
    func divComplexNumbers(firstNumber: ComplexNumber, secondNumber: ComplexNumber) -> ComplexNumber{
        var resultNumber = ComplexNumber();
        resultNumber.realPart = (firstNumber.realPart * secondNumber.realPart + firstNumber.imaginaryPart * secondNumber.imaginaryPart) / (pow(firstNumber.imaginaryPart, 2) + pow(secondNumber.imaginaryPart, 2));
        resultNumber.imaginaryPart = firstNumber.imaginaryPart * secondNumber.realPart - firstNumber.realPart * secondNumber.imaginaryPart / (pow(firstNumber.imaginaryPart, 2) + pow(secondNumber.imaginaryPart, 2));
        return resultNumber;
    }
    
    
    
}


