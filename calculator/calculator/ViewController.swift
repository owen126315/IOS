//
//  ViewController.swift
//  calculator
//
//  Created by Kwong Hau Shing on 10/10/2018.
//  Copyright © 2018年 Kwong Hau Shing. All rights reserved.
//

import UIKit

extension NSExpression {
    
    func toFloatingPoint() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
            let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
            return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
            return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .anyKey:
            fatalError("anyKey not yet implemented")
        case .block:
            fatalError("block not yet implemented")
        case .evaluatedObject, .variable, .keyPath:
            break // Nothing to do here
        }
        return self
    }
}

class ViewController: UIViewController,UITextFieldDelegate  {
    var memory:String? = nil
    @IBOutlet var EquationTextField: UITextField!
    @IBOutlet var AnswerLabel: UILabel!
    
    
    
    @IBAction func Button_1_pressed(_ sender: Any) {
        EquationTextField.insertText("1")
    }
    
    @IBAction func Button_2_pressed(_ sender: Any) {
        EquationTextField.insertText("2")
    }
    
    @IBAction func Button_3_pressed(_ sender: Any) {
        EquationTextField.insertText("3")
    }
    
    @IBAction func Button_4_pressed(_ sender: Any) {
        EquationTextField.insertText("4")
    }
    
    @IBAction func Button_5_pressed(_ sender: Any) {
        EquationTextField.insertText("5")
    }
    
    @IBAction func Button_6_pressed(_ sender: Any) {
        EquationTextField.insertText("6")
    }
    
    @IBAction func Button_7_pressed(_ sender: Any) {
        EquationTextField.insertText("7")
    }
    
    @IBAction func Button_8_pressed(_ sender: Any) {
        EquationTextField.insertText("8")
    }
    
    @IBAction func Button_9_pressed(_ sender: Any) {
        EquationTextField.insertText("9")
    }
    
    @IBAction func Button_0_pressed(_ sender: Any) {
        EquationTextField.insertText("0")
    }
    
    @IBAction func Button_plus_pressed(_ sender: Any) {
        EquationTextField.insertText("+")
    }
    
    @IBAction func Button_subtrack_pressed(_ sender: Any) {
        EquationTextField.insertText("-")
    }
    
    @IBAction func Button_times_pressed(_ sender: Any) {
        EquationTextField.insertText("*")
    }
    
    @IBAction func Button_divid_pressed(_ sender: Any) {
        EquationTextField.insertText("/")
    }
    
    @IBAction func Button_dot_pressed(_ sender: Any) {
        EquationTextField.insertText(".")
    }
    
    @IBAction func Button_leftbracket_pressed(_ sender: Any) {
        EquationTextField.insertText("(")
    }
    
    @IBAction func Button_righttbracket_pressed(_ sender: Any) {
        EquationTextField.insertText(")")
    }
    
    @IBAction func Button_percent_pressed(_ sender: Any) {
        EquationTextField.insertText("%")
    }
    
    @IBAction func Button_squareroot_pressed(_ sender: Any) {
        EquationTextField.insertText("√(")
    }
    
    @IBAction func Button_clear_pressed(_ sender: Any) {
        EquationTextField.text = ""
        AnswerLabel.text = ""
    }
    
    @IBAction func Button_delete_pressed(_ sender: Any) {
        let temp_str:String = EquationTextField.text!
        if EquationTextField.text!.count > 0{
            EquationTextField.text = (String)(temp_str.prefix(temp_str.count - 1))
            if EquationTextField.text!.count != 0 {
                calculate()
            }
            else {
                AnswerLabel.text = ""
            }
        }
        
    }

    @IBAction func Button_equal_pressed(_ sender: Any) {
        if AnswerLabel.text != "Error" && AnswerLabel.text != "nan"{
            EquationTextField.text = AnswerLabel.text
            AnswerLabel.text = ""
        }
        else{
            if AnswerLabel.text == "nan"{
                errorAlertion(4)
            }
            else if containConsecutiveOperator(){
                errorAlertion(0)
            }
            else if bracketsNotInPairs(){
                errorAlertion(1)
            }
            else if lastCharIsOperator(){
                errorAlertion(2)
            }
            else if containIllegalChar(){
                errorAlertion(5)
            }
        }
    }

    @IBAction func Button_memory_save_pressed(_ sender: Any) {
        memory = EquationTextField.text
    }
    
    @IBAction func Button_memory_load_pressed(_ sender: Any) {
        if memory != nil{
            EquationTextField.insertText(memory!)
        }
    }
    
    @IBAction func equation_changed(_ sender: Any) {
        if EquationTextField.text!.count > 0 {
            calculate()
        }
        else {
            AnswerLabel.text = ""
        }
    }
    
    func calculate(){
        if !containConsecutiveOperator() && !bracketsNotInPairs() && !lastCharIsOperator() && !containIllegalChar(){
            var temp_equation = EquationTextField.text!
            
            //convert √
            temp_equation = temp_equation.replacingOccurrences(of: "√", with: "sqrt")
            
            //convert %
            var lastOperatorPosition:Int? = nil
            var i = 0
            for char in temp_equation{
                if char == "+" || char == "-" || char == "*" || char == "/"{
                    lastOperatorPosition = i
                }
                if char == "%"{
                    var range = temp_equation.index(temp_equation.startIndex, offsetBy: lastOperatorPosition!+1) ..< temp_equation.index(temp_equation.startIndex, offsetBy: i)
                    let percentage_num = (String)((temp_equation[range] as NSString).doubleValue/100)
                    range = temp_equation.index(temp_equation.startIndex, offsetBy: lastOperatorPosition!+1) ..< temp_equation.index(temp_equation.startIndex, offsetBy: i+1)
                    temp_equation.replaceSubrange(range, with: percentage_num)
                }
                i+=1
            }

            //calculate the equation
            let equation = NSExpression(format: temp_equation)
            if let result = equation.toFloatingPoint().expressionValue(with: nil, context: nil) as? NSNumber {
                let x = result.doubleValue
                AnswerLabel.text = (String(format: "%.3f",x))
            }
            else {
                AnswerLabel.text = "Error"
            }
        }
        else{
            AnswerLabel.text = "Error"
        }
    }
    
    func containIllegalChar() -> Bool {
        for char in EquationTextField.text! {
            if char != "0" && char != "1" && char != "2" && char != "3" && char != "4" && char != "5" && char != "6" && char != "7" && char != "8" && char != "9" && char != "+" && char != "-" && char != "*" && char != "/" && char != "%" && char != "√" && char != "." && char != "(" && char != ")" {
                
                return true
            }
        }
        return false
    }
    
    func containConsecutiveOperator() -> Bool {
        var lastOperator:Character? = nil
        for char in EquationTextField.text!{
            if char == "+" || char == "-" || char == "*" || char == "/" || char == "%" || char == "." {
                if lastOperator == char || lastOperator == "+" || lastOperator == "-"{
                    return true
                }
                if lastOperator == "*" || lastOperator == "/" {
                    if char == "+" || char == "%" {
                        return true
                    }
                }
                lastOperator = char
            }
            else {
                lastOperator = nil
            }
        }
        return false
    }
    
    func bracketsNotInPairs() -> Bool {
        var bracketCount:Int = 0
        for char in EquationTextField.text! {
            if char == "("{
                bracketCount += 1
            }
            if char == ")"{
                bracketCount -= 1
            }
        }
        if bracketCount != 0{
            return true
        }
        return false
    }
    
    func lastCharIsOperator() -> Bool {
        let temp_equation = EquationTextField.text!
        if temp_equation.last == "+" || temp_equation.last == "-" || temp_equation.last == "*" || temp_equation.last == "/" || temp_equation.last == "." || temp_equation.last == "(" {
            return true
        }
        return false
    }
    
    func errorAlertion(_ errorType:Int) {
        switch(errorType){
        case 0: //Consecutive Operator Error
            let alert = UIAlertController(title: "Consecutive Operator Error", message: "Two or more consecutive operator excess in the equation!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Consecutive Operator Error")}))
            present(alert,animated: true, completion: nil)
            
        case 1: //Brackets Not In Pairs Error
            let alert = UIAlertController(title: "Brackets Not In Pairs Error", message: "There is a missing bracket or redundant bracket!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Brackets Not In Pairs Error")}))
            present(alert,animated: true, completion: nil)
            
        case 2: //Operator at last Error
            let alert = UIAlertController(title: "Operator at last Error", message: "Operator can not at last!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Operator at last Error")}))
            present(alert,animated: true, completion: nil)
        
        case 3: //Complex Number Error
            let alert = UIAlertController(title: "Complex Number Error", message: "The answer is a complex number!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Complex Number Error")}))
            present(alert,animated: true, completion: nil)
            
        case 4: //Calcuation Error
            let alert = UIAlertController(title: "Calcuation Error", message: "Can not calculate the answer!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Calcuation Error")}))
            present(alert,animated: true, completion: nil)
 
        case 5: //Illegal Charater Error
            let alert = UIAlertController(title: "Illegal Charater Error", message: "Illegal charater extis in the equation!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Illegal Charater Error")}))
            present(alert,animated: true, completion: nil)

        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        EquationTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        AnswerLabel.text = ""
        EquationTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
//HEHE
