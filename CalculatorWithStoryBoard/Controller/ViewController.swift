//
//  ViewController.swift
//  CalculatorWithStoryBoard
//
//  Created by Sourabh Wasnik on 04/06/2022.
//

import UIKit

class ViewController: UIViewController {
    
    //variables for normal operations
    var firstOperand = ""
    var secondOperand = ""
    
    //variable for advanced operations
    var inputNumbers = [String]()

    //variables for both types of operations
    var runningNumber = ""
    var engineOperation : CalcOperation = .NULL
    var result = ""
    
    //outlets
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var commaButton: RoundButton!
    @IBOutlet weak var operationLabel: UILabel!
    
    //functions
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "0"
        
        //make inputLabel shrinkable
        inputLabel.adjustsFontSizeToFitWidth = true
        inputLabel.minimumScaleFactor = 0.01
        
    }
    
    @IBAction func numberTapped(_ sender: RoundButton) {
        if runningNumber.count <= 8 {
            runningNumber += "\(sender.tag)"
            
            if notAdvancedOperations() {
                //update input label with operator and operands
                if operandAndOperatorsAvailable(){
                    inputLabel.text = firstOperand + engineOperation.rawValue + runningNumber

                } else {
                    inputLabel.text = runningNumber
                }
            } else { // Mean or median case selected
                if anyAdvancedOperationSelected(){
                    updateInputLabelWithArrayElements()
                }
            }
        }
    }
    
    @IBAction func clearTapped(_ sender: RoundButton) {
        runningNumber = ""
        firstOperand = ""
        secondOperand = ""
        engineOperation = .NULL
        resultLabel.text = "0"
        inputLabel.text = ""
        commaButton.isHidden = true
        inputNumbers = []
    }
    
    @IBAction func dotTapped(_ sender: RoundButton) {
        
        //restrict user from adding last digit as a dot
        if runningNumber.count <= 7 {
            runningNumber = formatNumber(number: runningNumber)
            handleMultipleDots()
        }
        
        //update UI
        if notAdvancedOperations() {
            if operandAndOperatorsAvailable(){
                inputLabel.text = firstOperand + engineOperation.rawValue + runningNumber
            } else {
                inputLabel.text = runningNumber
            }
        } else {
            updateInputLabelWithArrayElements()
        }
    }

    
    @IBAction func equalTapped(_ sender: RoundButton) {
        if notAdvancedOperations() {
            handleNormalOperations()
        } else {
            handleAdvancedOperations()
        }
    }
    
    @IBAction func addTapped(_ sender: RoundButton) {
        
        //toggle when user selects this operation after selecting mean/median
        toggleAdvancedOperationState(off: true)
        updateInputLabelWith(selectedOperation : .Add)
        prepareFor(selectedOperation : .Add)
        
    }
    
    @IBAction func subtractTapped(_ sender: RoundButton) {
        toggleAdvancedOperationState(off: true)
        updateInputLabelWith(selectedOperation : .Subtract)
        prepareFor(selectedOperation : .Subtract)
    }
    
    @IBAction func multiplyTapped(_ sender: RoundButton) {
        
        toggleAdvancedOperationState(off: true)
        updateInputLabelWith(selectedOperation : .Multiply)
        prepareFor(selectedOperation : .Multiply)
    }
    
    @IBAction func divideTapped(_ sender: RoundButton) {
        
        toggleAdvancedOperationState(off: true)
        updateInputLabelWith(selectedOperation : .Divide)
        prepareFor(selectedOperation : .Divide)
    }
    
    @IBAction func plusMinus(_ sender: RoundButton) {
        
        //toggle plusminus
        if runningNumber != "" && runningNumber != "."{
            if Double(runningNumber)! > 0 {
                runningNumber = String(-Double(runningNumber)!)
            } else if Double(runningNumber)! < 0 {
                runningNumber = String(abs(Double(runningNumber)!))
            }
            runningNumber = formatNumber(number: runningNumber)
        }
        //update UI
        if notAdvancedOperations() {
            inputLabel.text = runningNumber
        } else {//Mn, Md selected
            updateInputLabelWithArrayElements()
        }
        
    }
    
    @IBAction func meanTapped(_ sender: RoundButton) {
        toggleAdvancedOperationState(with : .Mean, off: false)
    }
    
    @IBAction func medianTapped(_ sender: RoundButton) {
        toggleAdvancedOperationState(with : .Median, off: false)
    }
    
    @IBAction func commaTapped(_ sender: RoundButton) {
        
        //add last element to the array
        if runningNumber != "" {
            inputNumbers.append(runningNumber)
            runningNumber = ""
        }
        //update UI
        if inputLabel.text != "" {
            inputLabel.text = inputLabel.text!.replacingOccurrences(of: "  )", with: ",  )")
        }
    }
    
    /*
     Utility functions
     */
    fileprivate func notAdvancedOperations() -> Bool {
        return engineOperation != .Mean && engineOperation != .Median
    }
    
    fileprivate func operandAndOperatorsAvailable() -> Bool {
        return inputLabel.text != nil && engineOperation != .NULL
    }
    
    fileprivate func anyAdvancedOperationSelected() -> Bool {
        return engineOperation == .Mean || engineOperation == .Median
    }
    
    /*
     Helper functions below
     */
    fileprivate func handleMultipleDots() {
        
        //restrict adding multiple dots
        if !runningNumber.contains("."){
            runningNumber += "."
        } else {
            //remove exisitng dot and append dot at the end
            runningNumber = runningNumber.replacingOccurrences(of: ".", with: "")
            runningNumber += "."
        }
    }
    
    fileprivate func updateInputLabelWithArrayElements() {
        var temp = ""
        for element in inputNumbers {
            temp +=  (element == "" ? "" : element + ", ")
        }
        inputLabel.text = "(  " + temp + runningNumber + "  )"
    }
    
    
    fileprivate func handleNormalOperations() {
        
        secondOperand = runningNumber
        var calculator = Calculator()
        
        if firstOperand == "" || secondOperand == "" || engineOperation == .NULL{
            return
        }
        //get the result from the Calculator
        result = String(calculator.execute(firstOperand: Double(firstOperand)!, secondOperand: Double(secondOperand)!, operation: engineOperation))
        
        formatAndCleanUpVariables()
        
        //Update UI
        resultLabel.text = result
    }
    
    fileprivate func handleAdvancedOperations() {
        //Mean or Median selected
        if anyAdvancedOperationSelected() {
            if runningNumber != "" {
                inputNumbers.append(runningNumber)
                runningNumber = ""
            }
            if inputNumbers.count <= 0 {
                return
            }
            
            /*pass the inputNumbers to engine, get the result and update UI*/
            var calculatorPro = CalculatorPro()
            
            //convert array elements, format the result
            let convertedArray = inputNumbers.compactMap(Double.init)
            result = String(calculatorPro.execute(inputArray: convertedArray, operation: engineOperation))
            result = formatNumber(number: result)
            
            //update UI
            resultLabel.text = result
        }
    }
    
    private func updateInputLabelWith(selectedOperation : CalcOperation){
        
        if runningNumber != ""{
            inputLabel.text = runningNumber + selectedOperation.rawValue
        } else {
            inputLabel.text = firstOperand + selectedOperation.rawValue
        }
    }
    
    private func prepareFor(selectedOperation : CalcOperation){
        if runningNumber != ""{
            firstOperand = runningNumber
        }
        runningNumber = ""
        engineOperation = selectedOperation
    }
    
    fileprivate func formatAndCleanUpVariables() {

        result = formatNumber(number: result)
        firstOperand = result // for continuing further operations
        runningNumber = firstOperand
        secondOperand = ""
        engineOperation = .NULL
        
    }
    
    fileprivate func toggleAdvancedOperationState(with operation : CalcOperation = .NULL, off : Bool) {
        if commaButton.isHidden == true && !off{
            commaButton.isHidden = false
            inputLabel.text = "( " + runningNumber + "  )"
            inputNumbers = []
            engineOperation = operation
            operationLabel.text = engineOperation.rawValue
            
        } else if commaButton.isHidden == false && !off && engineOperation != .NULL { // toggling between mean and median
            engineOperation = operation
            operationLabel.text = engineOperation.rawValue
            
        } else {
            commaButton.isHidden = true
            inputLabel.text = ""
            engineOperation = .NULL
            operationLabel.text = ""
        }
    }
    
    private func formatNumber(number: String) -> String{
        var number = number
        if number != "." && !number.isEmpty{
            if (Double(number)!.truncatingRemainder(dividingBy: 1) == 0) {
                number = "\(Int(Double(number)!))"
            } else {
                number = String(format:"%.2f", Double(number)!)
            }
        }
        return number
    }
    
}

