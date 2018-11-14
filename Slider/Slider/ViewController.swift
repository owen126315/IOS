//
//  ViewController.swift
//  Slider
//
//  Created by Kwong Hau Shing on 8/10/2018.
//  Copyright © 2018年 Kwong Hau Shing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var mSlider: UISlider!
    @IBOutlet var mLabel: UILabel!
    @IBAction func fontChange(_ sender: Any) {
        mLabel.font = UIFont(name: "Verdana", size: CGFloat(mSlider.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

