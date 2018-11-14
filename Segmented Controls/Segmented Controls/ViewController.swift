//
//  ViewController.swift
//  Segmented Controls
//
//  Created by Kwong Hau Shing on 8/10/2018.
//  Copyright © 2018年 Kwong Hau Shing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var segmentControlOutlet: UISegmentedControl!
    @IBOutlet var mLabel: UILabel!
    
    @IBAction func segmentAction(_ sender: Any) {
        switch segmentControlOutlet.selectedSegmentIndex {
        case 0:
            mLabel.text = "Segment 1 is selected"
        case 1:
            mLabel.text = "Segment 2 is selected"
        case 2:
            mLabel.text = "Segment 3 is selected"
        case 3:
            mLabel.text = "Segment 4 is selected"
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mLabel.text = "Nil"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

