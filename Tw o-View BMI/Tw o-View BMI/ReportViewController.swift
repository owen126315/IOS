//
//  ReportViewController.swift
//  Tw o-View BMI
//
//  Created by Kwong Hau Shing on 16/10/2018.
//  Copyright © 2018年 Kwong Hau Shing. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet var mImageView: UIImageView!
    @IBOutlet var bmiReport: UILabel!
    @IBOutlet var bmiComment: UILabel!
    
    var height: Float = 0
    var weight: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bmiValue = weight/(height*height)
        bmiReport.text = "Your BMI Value is \(String(format: "%.2f", bmiValue))."
        
        if bmiValue > 25 {
            bmiComment.text = "You should be on diet!"
            mImageView.image = UIImage(named: "bot_fat.png")
        }
        else if bmiValue < 20 {
            bmiComment.text = "You need more calories!"
            mImageView.image = UIImage(named: "bot_thin.png")
        }
        else {
            bmiComment.text = "You look great!"
            mImageView.image = UIImage(named: "bot_fit.png")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
