//
//  SecondViewController.swift
//  Tapped BMI
//
//  Created by Kwong Hau Shing on 16/10/2018.
//  Copyright © 2018年 Kwong Hau Shing. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController {

    
    @IBOutlet var mWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let mURL = URL(string: "https://en.wikipedia.org/wiki/Body_mass_index")!
        let request = URLRequest(url: mURL)
        mWebView.load(request)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

