//
//  VoucherViewController.swift
//  clinic_service_reserve_app
//
//  Created by Tse Shing Kung on 14/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit

class VoucherViewController: UIViewController{
    
    @IBOutlet var datePickerVoucher: UIDatePicker!
    @IBOutlet var amountText: UITextField!
    @IBOutlet var usageText: UITextField!
    var str: String = ""
    @IBAction func addVoucher(_ sender: Any) {
        if let a = Float(amountText.text!){
            let date:Date = datePickerVoucher.date
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            str = "\(formatter.string(from: date)) \(usageText.text!) $\(amountText.text!)"
            
            let itemsObject = UserDefaults.standard.object(forKey: "vouch")
            var items:[String]
            
            if let tempItems = itemsObject as? [String] {
                items = tempItems
                items.append(str)
                
            }else{
                items = [str]
            }
            UserDefaults.standard.set(items, forKey: "vouch")
            str = ""
            
        }else{
            let alert = UIAlertController(title: "Data Validation Error", message: "Input cannot be empty or non-numeric number", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action: UIAlertAction!) in print("Data Validation Checking Compleled")}))
            present(alert, animated: true, completion: nil)
        }
        
        _ = navigationController?.popViewController(animated: true)
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
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
