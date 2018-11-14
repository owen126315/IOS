//
//  ViewController.swift
//  switch
//
//  Created by Kwong Hau Shing on 8/10/2018.
//  Copyright © 2018年 Kwong Hau Shing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var mLabel: UILabel!
    @IBOutlet var switchOutlet: UISwitch!
    @IBAction func switchAction(_ sender: Any) {
        if switchOutlet.isOn {
            mLabel.text = "This Switch is ON"
        }
        else {
            mLabel.text = "This Switch is OFF"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if switchOutlet.isOn {
            mLabel.text = "This Switch is ON"
        }
        else {
            mLabel.text = "This Switch is OFF"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

