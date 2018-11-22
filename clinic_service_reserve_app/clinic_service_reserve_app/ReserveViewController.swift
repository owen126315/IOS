//
//  ReserveViewController.swift
//  clinic_service_reserve_app
//
//  Created by Kwong Hau Shing on 9/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import CocoaMQTT
import CoreData

class ReserveViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var reserveDatePicker: UIDatePicker!
    @IBOutlet weak var patientNameTextField: UITextField!
    @IBOutlet weak var patientAgeTextField: UITextField!
    @IBOutlet weak var patientSexSegmentedControl: UISegmentedControl!
    
    var mqttClient:CocoaMQTT?
    
    var personal : [Personal] = []
  
    
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func sexSelected(_ sender: Any)
    {
        patientNameTextField.resignFirstResponder()
        patientAgeTextField.resignFirstResponder()
    }
    
    @IBAction func reserveButtonPressed(_ sender: Any)
    {

        
        patientNameTextField.resignFirstResponder()
        patientAgeTextField.resignFirstResponder()
        if let patient_age = patientAgeTextField.text, let patient_name = patientNameTextField.text
        {
            //assign sex
            var patient_sex: String = ""
            if patientSexSegmentedControl.selectedSegmentIndex == 0
            {
                patient_sex = "Male"
            }
            else
            {
                patient_sex = "Female"
            }
            
            //put the infomation into a dictionary
            let dictionary = ["patient_name": patient_name, "patient_age": patient_age, "patient_sex": patient_sex] as [String : Any]
            
            //cast the dictionary into json string
            let jsonData = try! JSONSerialization.data(withJSONObject: dictionary)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            print("\n\(jsonString!)")
            
            //publish to topic-"patientInfo"
            mqttClient?.publish("patientInfo", withString: jsonString! as String)
            
            
            
            //alert
            let alert = UIAlertController(title: "Reserve Application Send", message: "We will notify you once the reservation is completed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:
                {(action: UIAlertAction!) in
                    print("Reserve Application Send")
                    self.navigationController?.popViewController(animated: true)
                }))
            present(alert,animated: true, completion: nil)
        }
        else
        {
            //numbers in name or empty
            let alert = UIAlertController(title: "Data Validation Error", message: "Name cannot be empty or non-numeric input", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Data Validation Checking Completed")}))
            present(alert,animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        patientNameTextField.delegate = self
        patientAgeTextField.delegate = self
        // Do any additional setup after loading the view.
        do{
            
            personal = try context.fetch(Personal.fetchRequest())
            var name: String = ""
            var age = ""
            var isMale = true
            if personal.count > 0 {
                for person in personal{
                    name = person.name!
                    age = person.age!
                    if (person.gender! == "Male"){
                        isMale = true
                    }
                    else
                    {
                        isMale = false
                    }
                }
                
                patientNameTextField.text = name
                patientAgeTextField.text = age
                
                if isMale{
                    patientSexSegmentedControl.selectedSegmentIndex = 0
                }else{
                    patientSexSegmentedControl.selectedSegmentIndex = 1
                }
             
                
                print("old")
            }
            else
            {
            
                print("new")
            }
        }catch{
            
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
