//
//  CalculatorPro.swift
//  CalculatorWithStoryBoard
//
//  Created by Sourabh Wasnik on 06/06/2022.
//

import Foundation

struct CalculatorPro {

    var result : Double?
    
    public mutating func execute(inputArray : [Double], operation : CalcOperation) -> Double{
        
        if operation == .Mean {
            
            result = calculateMean(inputArray: inputArray)
            
        } else if operation == .Median {
            
            //sort the input array
            var copiedArray = inputArray
            let length = copiedArray.count
            copiedArray.sort()
            
            if copiedArray.count % 2 == 0 {
                //even length; calculate mean of middle two numbers
                result =  calculateMean(firstMiddleIndexElement: copiedArray[(length / 2) - 1], secondMiddleIndexElement: copiedArray[length / 2])
            } else {
                //odd length; return the element at middle index
                result = Double(copiedArray[length / 2])
            }
        }
        return result!
    }
    
    //calcualates an average of its arguments 
    private func calculateMean(inputArray: [Double] = [], firstMiddleIndexElement : Double = Double(Int.min),secondMiddleIndexElement: Double = Double(Int.min) ) -> Double{
        var average : Double = 0
        
        if inputArray != []{
            var totalSum : Double = 0
            for element in inputArray {
                totalSum += element
            }
            average = totalSum / Double(inputArray.count)
        } else {
            average = Double((firstMiddleIndexElement + secondMiddleIndexElement) / 2)
        }
        
        return average
    }
}
