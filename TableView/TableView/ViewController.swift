//
//  ViewController.swift
//  TableView
//
//  Created by Kwong Hau Shing on 6/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let animals:[String] = ["Alligator", "Bat", "Bear", "Bird", "Camel", "Cat", "Deer", "Dog", "Eagle", "Fish", "Goat", "Jaguar", "Kangaroo", "Leopard", "Octopus", "Panda", "Pig", "Rabbit", "Shark", "Tiger", "Whale", "Zebra"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = animals[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

