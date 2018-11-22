//
//  BalanceViewController.swift
//  clinic_service_reserve_app
//
//  Created by Tse Shing Kung on 14/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var IntValue: Int {
        return (self as NSString).integerValue
    }
}

class BalanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var recordTable: UITableView!
    var items: [String] = []
    var list: [String] = []
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Voucher", for: indexPath as IndexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Record"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let itemsObject = UserDefaults.standard.object(forKey: "vouch")
        
        if let tempItems = itemsObject as? [String]{
            items = tempItems
        }
        bal()
        recordTable.reloadData()
    }
    
    func getAmount(itemString: String) -> Float{
        var j = -1
        var start = 0
        
        repeat{
            let index = itemString.index(itemString.endIndex, offsetBy: j)
            if (itemString[index] == "$") {
                start = j + 1
                let c = itemString.characters
                let r = c.index(c.endIndex, offsetBy: start)...c.index(c.endIndex, offsetBy: -1)
                return (itemString[r] as NSString).floatValue
            }
            j -= 1
        }while(j >= (0 - itemString.count))
        return 0.0
    }
    
    func bal(){
     var amount: Float = 0.0
     var balance: Float = 5000.0
     for i in 0..<items.count{
     amount += getAmount(itemString: items[i])
     }
     
     balance = balance - amount
     balanceLabel.text = "Balance: $\(String(balance))"
     
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            items.remove(at: indexPath.row)
            bal()
            recordTable.reloadData()
            UserDefaults.standard.set(items, forKey: "vouch")
        }
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
