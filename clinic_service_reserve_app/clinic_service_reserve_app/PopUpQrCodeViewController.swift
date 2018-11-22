//
//  PopUpQrCodeViewController.swift
//  clinic_service_reserve_app
//
//  Created by Kwong Hau Shing on 15/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit

class PopUpQrCodeViewController: UIViewController {


    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    var patientNo:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         let data = patientNo!.data(using: .ascii, allowLossyConversion: false)
         let filter = CIFilter(name: "CIQRCodeGenerator")
         filter?.setValue(data, forKey: "inputMessage")
         
         let img = UIImage(ciImage: (filter?.outputImage)!)
         self.qrCodeImageView.image = img
 
    }
    @IBAction func exit(_ sender: Any) {
     
        dismiss(animated: true, completion: nil)
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
