//
//  ViewController.swift
//  Core Data Demo
//
//  Created by Kwong Hau Shing on 12/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController
{

    var students : [Students] = []
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate);
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func addRecord(_ sender: Any)
    {
        if let name = nameTextField.text, let major = majorTextField.text, let id = Int64(idTextField.text!)
        {
            let student = Students(context: context)
            student.name = name
            student.major = major
            student.id = id
            appDelegate.saveContext()
            textView.text = "The record \(name) with id \(id) is created."
        }
        else
        {
            textView.text = "The record cannot be created. Please check the entries"
        }
    }
    
    @IBAction func showAllRecord(_ sender: Any)
    {
        do
        {
            students = try context.fetch(Students.fetchRequest())
            var listOfRecord: String = ""
            if students.count > 0
            {
                for student in students
                {
                    listOfRecord = listOfRecord + "\(student.name!) : \(student.major!) : \(student.id)\n"
                }
                textView.text = listOfRecord
            }
            else
            {
                textView.text = "No record is found"
            }
        }
        catch
        {
            textView.text = "Data fetch error"
        }
    }
    
    @IBAction func findRecord(_ sender: Any)
    {
        if let name = nameTextField.text
        {
            do
            {
                let fetchRequest : NSFetchRequest<Students> = Students.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                students = try context.fetch(fetchRequest)
                
                if students.count > 0
                {
                    var listOfRecord: String = ""
                    var isRecordFound = false
                    for student in students
                    {
                        listOfRecord = listOfRecord + "\(student.name!) : \(student.major!) : \(student.id)\n"
                        isRecordFound = true
                    }
                    
                    if isRecordFound
                    {
                        textView.text = listOfRecord
                    }
                    else
                    {
                        textView.text = "The record of \(name) is not found"
                    }
                }
                else
                {
                    textView.text = "No record is found"
                }
            }
            catch
            {
                textView.text = "Data fatch error"
            }
        }
        else
        {
            textView.text = "This record cannot be found. Please check the entries"
        }
    }
    
    @IBAction func updateRecord(_ sender: Any)
    {
        if let name = nameTextField.text, let major = majorTextField.text, let id = Int64(idTextField.text!)
        {
            do
            {
                let fetchRequest : NSFetchRequest<Students> = Students.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                students = try context.fetch(fetchRequest)
                
                if students.count > 0
                {
                    var listOfReocrd:String = ""
                    var isRocordFound = false
                    for student in students
                    {
                        student.major = major
                        student.id = id
                        listOfReocrd = listOfReocrd + "\(student.name!) : \(student.major!) : \(student.id)\n"
                        isRocordFound = true
                    }
                    if isRocordFound
                    {
                        textView.text = listOfReocrd
                        appDelegate.saveContext()
                    }
                    else
                    {
                        textView.text = "The record of \(name) is not found"
                    }
                }
                else
                {
                    textView.text = "No found is found"
                }
            }
            catch
            {
                textView.text = "Data fetch error"
            }
        }
        else
        {
            textView.text = "This record cannot be found. Please check the entries"
        }
    }
    
    @IBAction func deleteRecord(_ sender: Any)
    {
        if let name = nameTextField.text
        {
            do
            {
                let fetchRequest : NSFetchRequest<Students> = Students.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                students = try context.fetch(fetchRequest)
                
                if students.count > 0
                {
                    var listOfRecord: String = ""
                    var isRecordFound = false
                    for student in students
                    {
                        listOfRecord = listOfRecord + "The record of [\(student.name!) : \(student.major!) : \(student.id) is deleted]\n"
                        context.delete(student)
                        isRecordFound = true
                    }
                    
                    if isRecordFound
                    {
                        textView.text = listOfRecord
                        appDelegate.saveContext()
                    }
                    else
                    {
                        textView.text = "No record is found"
                    }
                }
                else
                {
                    textView.text = "No record is found"
                }
            }
            catch
            {
                textView.text = "Data fetch error"
            }
        }
        else
        {
            textView.text = "This record cannot be found. Please check the entries"
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

