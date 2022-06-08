//
//  Calculator.swift
//  CalculatorWithStoryBoard
//
//  Created by Sourabh Wasnik on 04/06/2022.
//

import Foundation

struct Calculator {

    var result : Double?
    
    public mutating func execute(firstOperand: Double, secondOperand : Double, operation : CalcOperation) -> Double{
        if operation == .Add {
            result = firstOperand + secondOperand
            
        } else if operation == .Subtract {
            result = firstOperand - secondOperand
            
        } else if operation == .Multiply {
            result = firstOperand * secondOperand
            
        } else if operation == .Divide {
            result = firstOperand / secondOperand
        
        }
        
        return result!
    }
    
}
