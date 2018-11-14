//
//  FirstViewController.swift
//  Tapped BMI
//
//  Created by Kwong Hau Shing on 16/10/2018.
//  Copyright © 2018年 Kwong Hau Shing. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var mImageView: UIImageView!
    @IBOutlet var heightInput: UITextField!
    @IBOutlet var weightInput: UITextField!
    @IBOutlet var bmiReport: UILabel!
    @IBOutlet var bmiComment: UILabel!
    @IBAction func bmiButton(_ sender: Any)
    {
        heightInput.resignFirstResponder()
        weightInput.resignFirstResponder()
        if let height = Float(heightInput.text!), let weight = Float(weightInput.text!)
        {
            let bmi = BmiModel(heightInMeter: height/100.0, weightInkg: weight)
            
            bmiReport.text = "Your BMI Value is \(String(format: "%.2f",bmi.getValue()))."
            bmiComment.text = bmi.getComment()
            mImageView.image = UIImage(named: bmi.getImageFilename())
            
            UserDefaults.standard.set(heightInput.text!, forKey: "height")
            UserDefaults.standard.set(weightInput.text!, forKey: "weight")
        }
        else
        {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
