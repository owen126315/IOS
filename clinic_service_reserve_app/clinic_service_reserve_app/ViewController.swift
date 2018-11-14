//
//  ViewController.swift
//  clinic_service_reserve_app
//
//  Created by Kwong Hau Shing on 9/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {

    @IBOutlet weak var patientNumberLabel: UILabel!
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    var subscribeBool: Bool = false
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "35.220.213.62", port: 1883)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mqtt_config()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let reserve:ReserveViewController = segue.destination as! ReserveViewController
        reserve.mqttClient = mqttClient
    }
    
    func mqtt_config()
    {
        mqttClient.didConnectAck = { mqtt, ack in
            if ack == .accept
            {
                mqtt.subscribe("patientNo", qos: CocoaMQTTQOS.qos2)
                mqtt.subscribe("currentNo", qos: CocoaMQTTQOS.qos2)
            }
        }
        mqttClient.didReceiveMessage = { mqtt, message, id in
            if message.topic == "patientNo"
            {
                self.patientNumberLabel.text = message.string
                
                let data = message.string!.data(using: .ascii, allowLossyConversion: false)
                let filter = CIFilter(name: "CIQRCodeGenerator")
                filter?.setValue(data, forKey: "inputMessage")
                
                let img = UIImage(ciImage: (filter?.outputImage)!)
                self.qrCodeImageView.image = img
                
                // alert
                let alert = UIAlertController(title: "Reservation Success", message: "Your reservation number is \(message.string!)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Reservation No: \(message.string!)")}))
                
                // show the number on label
                self.present(alert,animated: true, completion: nil)
            }
            if message.topic == "currentNo"
            {
                self.currentNumberLabel.text = message.string
                // do checking if the difference btween current number and patient number is smaller than 10
            }

        }
        mqttClient.connect()
    }
    //123
}

