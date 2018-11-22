//
//  AppointmentViewController.swift
//  clinic_service_reserve_app
//
//  Created by Tse Shing Kung on 16/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import CocoaMQTT
import CoreData


class AppointmentViewController: UIViewController {
    
    @IBOutlet var reasonText: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    var str: String = ""
    
    var mqttClient:CocoaMQTT?

    var personal : [Personal] = []
    
    var appointment : [Appointment] = []
    
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func makeApp(){
        let date:Date = datePicker.date
        let formatter:DateFormatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let sendDate = formatter.string(from: date)
        str = "\(formatter.string(from: date)) \(reasonText.text!)"
        
        let appoint = Appointment(context: context)
        
        appoint.date = date
        appoint.detail = reasonText.text
        appoint.id = "1"
        appoint.status = "Waiting Confirm"
        appDelegate.saveContext()
        
        
        var name: String = ""
        var age = ""
        var gender = ""
       
        do{
            
            personal = try context.fetch(Personal.fetchRequest())
           
            
            if personal.count > 0 {
                for person in personal{
                    name = person.name!
                    age = person.age!
                    gender = person.gender!
                }
            }
            else
            {
            }
        }catch{
            
        }

        let itemsObject = UserDefaults.standard.object(forKey: "items")
        var items:[String]
        
        if let tempItems = itemsObject as? [String] {
            items = tempItems
            items.append(str)
            
        }else{
            items = [str]
        }
        UserDefaults.standard.set(items, forKey: "items")
        str = ""
        
        //put the infomation into a dictionary
        let dictionary = ["patient_name": name, "patient_age": age, "patient_sex": gender, "Reason": reasonText.text!, "Date":sendDate] as [String : Any]
        
        //cast the dictionary into json string
        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        print("\n\(jsonString!)")
        
        //publish to topic-"patientInfo"
        mqttClient?.publish("appointmentInit", withString: jsonString! as String)
        
        
        let alert = UIAlertController(title: "Reserve Application Send", message: "We will notify you once the reservation is completed", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close",style: .default, handler:
            {(action: UIAlertAction!) in
                print("Reserve Application Send")
                self.navigationController?.popViewController(animated: true)
        }))
        present(alert,animated: true, completion: nil)
    }
    
    @IBAction func makeAppointment(_ sender: Any) {
        let date:Date = datePicker.date
        let formatter:DateFormatter = DateFormatter()
        let currDate = Date()
        let currFormatter:DateFormatter = DateFormatter()
        
        currFormatter.dateFormat = "yyyy"
        formatter.dateFormat = "yyyy"
        if let reason = reasonText.text{
            if (formatter.string(from: date) > currFormatter.string(from: currDate)){
                makeApp()
            }else if(formatter.string(from: date) == currFormatter.string(from: currDate)){
                currFormatter.dateFormat = "MM"
                formatter.dateFormat = "MM"
                if (formatter.string(from: date) > currFormatter.string(from: currDate)){
                    makeApp()
                }else if (formatter.string(from: date) == currFormatter.string(from: currDate)){
                    currFormatter.dateFormat = "dd"
                    formatter.dateFormat = "dd"
                    if (formatter.string(from: date) >= currFormatter.string(from: currDate)){
                        if(date>currDate){
                            makeApp()
                        }
                    }else{
                        alert()
                    }
                }else{
                    alert()
                }
            }else{
                alert()
            }
        }else{
            let alert = UIAlertController(title: "Data Validation Error", message: "Reason cannot be empty or non-numeric input", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Data Validation Checking Completed")}))
            present(alert,animated: true, completion: nil)
        }
        
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    func alert(){
        let alert = UIAlertController(title: "Data Validation Error", message: "The Date is Invalid", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action: UIAlertAction!) in print("Data Validation Checking Compleled")}))
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
