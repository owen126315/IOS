//
//  PopUpAppointmentViewController.swift
//  clinic_service_reserve_app
//
//  Created by Tse Shing Kung on 18/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit

class PopUpAppointmentViewController: UIViewController {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var reasonLabel: UILabel!
    @IBOutlet var reasonText: UITextField!
    var str: String = ""
    
    
    var dateText: String = "2018-11-20 01:00"
    var reason: String = "Stomachache"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateLabel.text = UserDefaults.standard.object(forKey: "pass") as! String
        reasonLabel.text = "Reason: " + reason
    }
    @IBAction func updateApp(_ sender: Any) {
        let date:Date = datePicker.date
        let formatter:DateFormatter = DateFormatter()
        let currDate = Date()
        let currFormatter:DateFormatter = DateFormatter()
        
        currFormatter.dateFormat = "yyyy"
        formatter.dateFormat = "yyyy"
        
        if (formatter.string(from: date) > currFormatter.string(from: currDate)){
            
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateLabel.text = "Date: " + formatter.string(from: date)
            if(reasonText.text != ""){
                reasonLabel.text = "Reason: " + reasonText.text!
            }
            
            
            
        }else if(formatter.string(from: date) == currFormatter.string(from: currDate)){
            currFormatter.dateFormat = "MM"
            formatter.dateFormat = "MM"
            if (formatter.string(from: date) > currFormatter.string(from: currDate)){
                
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                dateLabel.text = "Date: " + formatter.string(from: date)
                if(reasonText.text != ""){
                    reasonLabel.text = "Reason: " + reasonText.text!
                }
                
            }else if (formatter.string(from: date) == currFormatter.string(from: currDate)){
                currFormatter.dateFormat = "dd"
                formatter.dateFormat = "dd"
                if (formatter.string(from: date) >= currFormatter.string(from: currDate)){
                    
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    dateLabel.text = "Date: " + formatter.string(from: date)
                    if(reasonText.text != ""){
                        reasonLabel.text = "Reason: " + reasonText.text!
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
        
        
        
        
        
        
        
        /*let date:Date = datePicker.date
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateLabel.text = "Date: " + formatter.string(from: date)
        reasonLabel.text = "Reason: " + reasonText.text!*/
    }
    
    @IBAction func cancelApp(_ sender: Any) {
    }
    
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func makeApp(){
        let date:Date = datePicker.date
        let formatter:DateFormatter = DateFormatter()
        let currDate = Date()
        let currFormatter:DateFormatter = DateFormatter()
        
        currFormatter.dateFormat = "yyyy"
        formatter.dateFormat = "yyyy"
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        str = "\(formatter.string(from: date)) \(reasonText.text!)"
        
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
    }
    
    
    func alert(){
        let alert = UIAlertController(title: "Data Validation Error", message: "The Date is Invalid", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action: UIAlertAction!) in print("Data Validation Checking Compleled")}))
        present(alert, animated: true, completion: nil)
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
