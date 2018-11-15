//
//  ViewController.swift
//  clinic_service_reserve_app
//
//  Created by Kwong Hau Shing on 9/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import CocoaMQTT
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var patientNumberLabel: UILabel!
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var popUpQRcodeButton: UIButton!
    
    
    var audioPlayer = AVAudioPlayer()
    var subscribeBool: Bool = false
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "35.220.213.62", port: 1883)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = Bundle.main.path(forResource: "iphone", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print ("There is an issue with this code!")
        }
        mqtt_config()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let button = sender as! UIButton
        if button == reserveButton {
            let reserve:ReserveViewController = segue.destination as! ReserveViewController
            reserve.mqttClient = mqttClient
        }
        else if button == popUpQRcodeButton {
            if let _ = Int64(patientNumberLabel.text!) {
                let qrCode:PopUpQrCodeViewController = segue.destination as! PopUpQrCodeViewController
                qrCode.patientNo = patientNumberLabel.text!
            }
            else {
                // alert
                let alert = UIAlertController(title: "Reservation Is not Yet Done", message: "You do not have your reservation number", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Reservation Is not Yet Done")}))
                
                // show the number on label
                self.present(alert,animated: true, completion: nil)
            }
        }
        

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
            self.audioPlayer.play()
            if message.topic == "patientNo"
            {
                self.patientNumberLabel.text = message.string
                self.patientNumberLabel.textColor = UIColor.blue
                self.patientNumberLabel.blink()
                
                // alert
                let alert = UIAlertController(title: "Reservation Success", message: "Your reservation number is \(message.string!)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Reservation No: \(message.string!)")}))
                
                // show the number on label
                self.present(alert,animated: true, completion: nil)
            }
            if message.topic == "currentNo"
            {
                self.currentNumberLabel.text = message.string
                self.currentNumberLabel.textColor = UIColor.red
                self.currentNumberLabel.blink()
                // do checking if the difference btween current number and patient number is smaller than 10
            }

        }
        mqttClient.connect()
    }
}

extension UIView {
    func blink() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.isRemovedOnCompletion = false
        animation.fromValue           = 1
        animation.toValue             = 0
        animation.duration            = 0.8
        animation.autoreverses        = true
        animation.repeatCount         = 2
        animation.beginTime           = CACurrentMediaTime() + 0.5
        self.layer.add(animation, forKey: nil)
    }
}
