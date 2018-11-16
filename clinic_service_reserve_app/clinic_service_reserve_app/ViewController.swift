//
//  ViewController.swift
//  clinic_service_reserve_app
//
//  Created by Kwong Hau Shing on 9/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import CocoaMQTT
import CoreData
import AVFoundation
import Foundation
//, UITableViewDelegate, UITableViewDataSource
class ViewController: UIViewController {

    @IBOutlet weak var patientNumberLabel: UILabel!
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var QRCodeButton: UIButton!
    
    //@IBOutlet weak var reserveTableView: UITableView!
    
    
    var reservations: [Reserves] = []
    var audioPlayer = AVAudioPlayer()
    var subscribeBool: Bool = false
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "35.220.213.62", port: 1883)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QRCodeButton.isHidden = true
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
    /*
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        reserveTableView.reloadData()
    }
*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let button = sender as! UIButton
        if button == reserveButton {
            let reserve:ReserveViewController = segue.destination as! ReserveViewController
            reserve.mqttClient = mqttClient
        }
            
        else if button == QRCodeButton {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let reserve = reservations[indexPath.row]
        cell.textLabel?.text = "Name : \(reserve.patient_name!)  Date : \(reserve.reserve_date!) Patient Number : \(reserve.patient_No!)"
        return cell
    }
    
    func getData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            reservations = try context.fetch(Reserves.fetchRequest())
        }
        catch
        {
            print("Fatched Failed")
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
                print("in")
                let data = message.string!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    if let name = json["patient_name"], let num = json["patient_No"], let sex = json["patient_sex"], let age = json["patient_age"], let date = json["reserve_date"]  {
                        /*
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        let reserve = Reserves(context: context)
                        reserve.patient_name = String(describing: name)
                        reserve.patient_age = String(describing: age)
                        reserve.patient_sex = String(describing: sex)
                        reserve.patient_No = String(describing: num)
                        reserve.reserve_date = String(describing: date)
                        */
                        //(UIApplication.shared.delegate as! AppDelegate).saveContext()
                        
                        //self.reserveTableView.reloadData()
                        
                        
                        self.patientNumberLabel.text = String(describing: num)
                        self.patientNumberLabel.textColor = UIColor.blue
                        self.patientNumberLabel.blink()
                        
                        // enable the qrcode button
                        self.QRCodeButton.isHidden = false
                        
                        // alert
                        let alert = UIAlertController(title: "Reservation Success", message: "Patient Name:\(name) \nPatient Number: \(num) \nReserve Date: \(date)", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print("Patient Name:\(name) \nPatient Number: \(num) \nReserve Date: \(date)")}))
                         
                        // show the number on label
                        self.present(alert,animated: true, completion: nil)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
                
 

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

struct ReserveRecord : Codable {
    var patient_name:String
    var patient_sex:String
    var patient_age:String
    var reserve_date:String
    var patient_No:String
}

