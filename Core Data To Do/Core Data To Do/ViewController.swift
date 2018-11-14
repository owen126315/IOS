//
//  ViewController.swift
//  Core Data To Do
//
//  Created by Kwong Hau Shing on 12/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let task = tasks[indexPath.row]
        if task.isImportant
        {
            cell.textLabel?.text = "* \(task.name!)"
        }
        else
        {
            cell.textLabel?.text = task.name!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete
        {
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do
            {
                tasks = try context.fetch(Tasks.fetchRequest())
            }
            catch
            {
                print("Fatched Failed")
            }
        }
        tableView.reloadData()
    }

    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Tasks] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        tableView.reloadData()
    }
    
    func getData()
    {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            tasks = try context.fetch(Tasks.fetchRequest())
        }
        catch
        {
            print("Fatched Failed")
        }
    }

}

