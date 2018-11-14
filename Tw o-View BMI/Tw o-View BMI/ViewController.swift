//
//  ViewController.swift
//  Tw o-View BMI
//
//  Created by Kwong Hau Shing on 16/10/2018.
//  Copyright © 2018年 Kwong Hau Shing. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var heightInput: UITextField!
    @IBOutlet var weightInput: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        heightInput.resignFirstResponder()
        weightInput.resignFirstResponder()
        if let height = Float(heightInput.text!), let weight = Float(weightInput.text!)
        {
            let report:ReportViewController = segue.destination as! ReportViewController
            report.height = height/100
            report.weight = weight
        }
        else {
            let alert = UIAlertController(title: "Data Validation Error", message: "Height and Weight can not be empty or non-numeric input", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Data Validation Checking Completed")}))
            present(alert,animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        heightInput.delegate = self
        weightInput.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

