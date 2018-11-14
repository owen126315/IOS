//
//  ViewController.swift
//  tryMQTT2
//
//  Created by Kwong Hau Shing on 8/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController
{
    var subscribeBool: Bool = false
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "35.220.213.62", port: 1883)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mqtt_config()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var receiveMessage: UITextField!
    
    @IBAction func gpio40SW(_ sender: UISwitch)
    {
        if sender.isOn {
            mqttClient.publish("rpi/gpio", withString: "on")
        }
        else {
            mqttClient.publish("rpi/gpio", withString: "off")
        }
    }
    
    @IBAction func disconnectButton(_ sender: Any)
    {
        mqttClient.disconnect()
    }
    
    func mqtt_config()
    {
        mqttClient.didConnectAck = { mqtt, ack in
            if ack == .accept {
                mqtt.subscribe("try", qos: CocoaMQTTQOS.qos2)
            }
        }
        mqttClient.didReceiveMessage = { mqtt, message, id in
            self.receiveMessage.text = message.string
        }
        mqttClient.connect()
    }
    
    
    
}


