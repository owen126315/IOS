//
//  InfoViewController.swift
//  clinic_service_reserve_app
//
//  Created by admin on 11/18/18.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    var personal : [Personal] = []
    var newRecord = false

    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func ConfirmPressed(_ sender: Any) {
        
        nameText.resignFirstResponder()
        ageText.resignFirstResponder()
        let age = ageText.text
        let name = nameText.text
        if age != "" && name != ""{
            
            var gender: String = ""
            if genderSegment.selectedSegmentIndex == 0
            {
                gender = "Male"
            }
            else
            {
                gender = "Female"
            }
            
            
            if (newRecord == true){
                //add
                let person = Personal(context: context)
                
                person.id = 1
                person.name = name
                person.age = age
                person.gender = gender
                appDelegate.saveContext()
                
                let alert = UIAlertController(title: "Sucess!", message: "Personal data added", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close",style: .default, handler:
                    {(action: UIAlertAction!) in
                        print("Sucess!")
                        self.navigationController?.popViewController(animated: true)
                }))
                present(alert,animated: true, completion: nil)
            } else{
                //update
                do{
                    let fetchRequest : NSFetchRequest<Personal> = Personal.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %d", 1)
                    
                    personal = try context.fetch(fetchRequest)
                    
                    if personal.count > 0 {
                        for person in personal{
                            person.name = name
                            person.age = age
                            person.gender = gender
                        }
                        appDelegate.saveContext()
                        
                        let alert = UIAlertController(title: "Sucess!", message: "Personal data updated", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Close",style: .default, handler:
                            {(action: UIAlertAction!) in
                                print("Sucess!")
                                self.navigationController?.popViewController(animated: true)
                        }))
                        present(alert,animated: true, completion: nil)
                    }
                }catch{}
                
            }
        }else{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
        ageText.delegate = self

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
                
                nameText.text = name
                ageText.text = age
                
                if isMale{
                    genderSegment.selectedSegmentIndex = 0
                }else{
                    genderSegment.selectedSegmentIndex = 1
                }
                newRecord = false
                
                print("old")
            }
            else
            {
                newRecord = true
                print("new")
            }
        }catch{
            
        }
        
        
        // Do any additional setup after loading the view.
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
