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
    
    /*
     when user taps on any number, this function is invoked
     It keeps track of the running number and updates the UI and any operands
     */
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
    
    /*
     Resets all variables
     */
    @IBAction func clearTapped(_ sender: RoundButton) {
        runningNumber = ""
        firstOperand = ""
        secondOperand = ""
        engineOperation = .NULL
        resultLabel.text = "0"
        inputLabel.text = ""
        commaButton.isHidden = true
        inputNumbers = []
        operationLabel.text = ""
    }
    
    /*
     Turns the running number into a decimal value
     */
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

    /*
     Calculates the result for both types of operations
     */
    @IBAction func equalTapped(_ sender: RoundButton) {
        if notAdvancedOperations() {
            handleNormalOperations()
        } else {
            handleAdvancedOperations()
        }
    }
    
    
    /*
     For below functions,
     addTapped;
     subtractTapped;
     multiplyTapped;
     divideTapped;
     If Advanced operatios are already selected, these methods turn them off.
     If user has only typed 1 number, it only appends the operator to the number.
     If user has already typed an operation e.g. (5+3), and when this function is invoked, it calculates the result e.g. (8+) and appends the operator for further calcualtion
     */
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
    
    
    //Changes the sign of the running number and updates the UI
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
            if firstOperand != "" && engineOperation != .NULL {
                inputLabel.text = firstOperand + engineOperation.rawValue + runningNumber
            } else {
                inputLabel.text = runningNumber
            }
            
        } else {//Mn, Md selected
            updateInputLabelWithArrayElements()
        }
        
    }
    
    /*
     For below functions,
     meanTapped;
     medianTapped;
     They change the UI (adds parantheses, comma button & label for the operation) for the user to be able to add a number
     */
    @IBAction func meanTapped(_ sender: RoundButton) {
        toggleAdvancedOperationState(with : .Mean, off: false)
    }
    
    @IBAction func medianTapped(_ sender: RoundButton) {
        toggleAdvancedOperationState(with : .Median, off: false)
    }
    
    /*
     Once tapped, adds the running number to the array and updates the UI
     */
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
     Utility functions below
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
    
    //Restricts adding multiple dots
    fileprivate func handleMultipleDots() {
        
        if !runningNumber.contains("."){
            runningNumber += "."
        } else {
            //remove exisitng dot and append dot at the end
            runningNumber = runningNumber.replacingOccurrences(of: ".", with: "")
            runningNumber += "."
        }
    }
    
    //Updates UI with array elements
    fileprivate func updateInputLabelWithArrayElements() {
        var temp = ""
        for element in inputNumbers {
            temp +=  (element == "" ? "" : element + ", ")
        }
        inputLabel.text = "(  " + temp + runningNumber + "  )"
    }
    
    
    /*
     Called from equalTapped() & handleCalculationsWithoutEqualTapped().
     Creates an object of Calculator and updats the Result in the UI
    */
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
    
    /*
     Called from equalTapped().
     Creates an object of CalculatorPro and updats the Result in the UI
     */
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
    
    //Updates UI with selected operation
    private func updateInputLabelWith(selectedOperation : CalcOperation){
        
        if runningNumber != ""{
            inputLabel.text = runningNumber + selectedOperation.rawValue
        } else {
            inputLabel.text = firstOperand + selectedOperation.rawValue
        }
    }
    
    //Sets the main operation that is to be carried out
    private func prepareFor(selectedOperation : CalcOperation){
        if runningNumber != ""{
            firstOperand = runningNumber
        }
        runningNumber = ""
        engineOperation = selectedOperation
    }
    
    //called from handleNormalOperations()
    fileprivate func formatAndCleanUpVariables() {
        result = formatNumber(number: result)
        firstOperand = result // for continuing further operations
        runningNumber = firstOperand
        secondOperand = ""
        engineOperation = .NULL
        
    }
    
    /*
     Called from toggleAdvancedOperationState() for normal operations.
     This function checks if the input string already has any operands and based on that, calls handleNormalOperations()
     */
    fileprivate func handleCalculationWithoutEqualTapped() {
        
        if let text = inputLabel.text, !text.isEmpty {
                        
            if text.contains("--") {//when second operand has a negative sign & main operator is -ve
                
                if splitSuccess(text,mainOperator:  "--") { handleNormalOperations() }
                
            } else if text.contains("+-") { //when second operand has a negative sign & main operator is +ve
                
                if splitSuccess(text,mainOperator:  "+-"){ handleNormalOperations() }
                
            } else if text.contains("*-") { //when second operand has a negative sign & main operator is *(multiply)
                
               if splitSuccess(text,mainOperator:  "*-") { handleNormalOperations() }
                
            } else if text.contains("/-") { //when second operand has a negative sign & main operator is /(divide)
                
                if splitSuccess(text,mainOperator:  "/-") { handleNormalOperations() }
                
           } else if text.contains("+") || text.contains("-") || text.contains("*") || text.contains("/"){ // when no negative sign is in inputLabel
                var elements = text.components(separatedBy: ["+", "-", "*", "/"])
                
                //preprocess elements array
                if "\(text.prefix(1))" == "-"{
                    let itemOneToRemove = "-"
                    let itemTwoToRemove = ""
                    for object in elements {
                        if object == itemOneToRemove {
                            elements.remove(at: elements.firstIndex(of: itemOneToRemove)!)
                        }
                        if object == itemTwoToRemove {
                            elements.remove(at: elements.firstIndex(of: itemTwoToRemove)!)
                        }
                    }
                }
                // if operands exist in the array, calcualte result
                if elements.count == 2 {
                    firstOperand = elements[0]
                    secondOperand = elements[1]
                    if "\(text.prefix(1))" == "-"{
                        firstOperand = "-" + firstOperand
                    }
                    handleNormalOperations()
                }
            }
        }
    }
    
    //splits the passed string by second argument, sets the first & second operands, and notifies the caller
    fileprivate func splitSuccess(_ text: String, mainOperator : String) -> Bool{
        let seperatedNumbers = text.replacingOccurrences(of: mainOperator, with: ",")
        let elements = seperatedNumbers.components(separatedBy: [","])
        if elements.count == 2 {
            firstOperand = elements[0]
            secondOperand = "-" + elements[1]
            return true
        }
        return false
    }
    
    /*
     Called from all the opeator buttons
     If called from normal operators, it turns advanced operation off, and calls handleCalculationWithoutEqualTapped()
     */
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
            handleCalculationWithoutEqualTapped()
            inputLabel.text = ""
            engineOperation = .NULL
            operationLabel.text = ""
        }
    }
    
    // A helper function for formatting the number
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

