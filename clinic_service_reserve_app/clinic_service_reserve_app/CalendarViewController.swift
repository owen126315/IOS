//
//  CalendarViewController.swift
//  clinic_service_reserve_app
//
//  Created by Tse Shing Kung on 16/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CocoaMQTT
import CoreData

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var appointmentTable: UITableView!

    
    @IBOutlet weak var appointBar: UIBarButtonItem!
    
    
    var items: [String] = []
    var list: [String] = []
    var appointlist: [String] = []
    var appointState = [String:String]()
    
    var audioPlayer = AVAudioPlayer()
    var subscribeBool: Bool = false
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "35.220.213.62", port: 1883)
    
    var appoint : [Appointment] = []
    
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Appointment"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pop = self.storyboard?.instantiateViewController(withIdentifier: "PopUpAppointmentViewController") as! PopUpAppointmentViewController
        self.navigationController?.pushViewController(pop, animated: true)
        //UserDefaults.standard.removeObject(forKey: "pass")
        let itemsObject = UserDefaults.standard.object(forKey: "pass")
        let str = items[indexPath.row]
        UserDefaults.standard.set(str, forKey: "pass")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        let itemsObject = UserDefaults.standard.object(forKey: "items")
       
        if let tempItems = itemsObject as? [String]{
            
            /*let ymd = "\(String(currentYear))-\(String(currentMonth))"
            var checking = tempItems
            var i = 0
            if(checking.count > 0){
                repeat{
                    
                    if(checkDate(itemString: checking[i]) != ymd){
                        checking.remove(at: i)
                        i -= 1
                    }
                    
                    
                    i += 1
                }while(i < checking.count)
            }*/
            //items = checking
            
            items = tempItems
        }
        calendar.reloadData()
        appointmentTable.reloadData()
    }
    
    /*func checkDate(itemString: String) -> String{
        var j = 0
        var end = 0
        var counter = 0
        
        repeat{
            let index = itemString.index(itemString.startIndex, offsetBy: j)
            if (itemString[index] == "-") {
                counter += 1
                if counter > 1{
                    end = j - 1
                    let c = itemString.characters
                    let r = c.index(c.startIndex, offsetBy: 0)...c.index(c.startIndex, offsetBy: end)
                    return String(itemString[r])
                }
                
            }
            j += 1
        }while(j < itemString.count)
        return ""
    }*/
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            items.remove(at: indexPath.row)
            appointmentTable.reloadData()
            UserDefaults.standard.set(items, forKey: "items")
        }
    }
    
    
    @IBOutlet var calendar: UICollectionView!
    @IBOutlet var timeLabel: UILabel!
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var currentDay = Calendar.current.component(.day, from: Date())
    
    
    @IBAction func lastMonth(_ sender: Any) {
        currentMonth -= 1
        if currentMonth == 0{
            currentMonth = 12
            currentYear -= 1
        }
        setUp()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        currentMonth += 1
        if currentMonth == 13{
            currentMonth = 1
            currentYear += 1
        }
        setUp()
    }
    
    var numberOfDaysInThisMonth:Int{
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInThisMonth + howManyItemsShouldIAdd
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        findApp()
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let curr = formatter.string(from: date)
      
        let ymd = "\(String(currentYear))-\(String(currentMonth))-\(String(currentDay))"
        
        
        if let textLabel = cell.contentView.subviews[0] as? UILabel{
      
            
            if indexPath.row < howManyItemsShouldIAdd{
                textLabel.text = ""
                textLabel.backgroundColor = .gray
            }else{
                textLabel.text = "\(indexPath.row + 1 - howManyItemsShouldIAdd)"
                textLabel.backgroundColor = .white
                
                if ((textLabel.text == String(currentDay)) && (curr == ymd)){
                    textLabel.backgroundColor = UIColor(red:0.70, green:0.92, blue:0.96, alpha:1.0)
                }else{
                    textLabel.textColor = .black
                }
                let ymd = "\(String(currentYear))-\(String(currentMonth))-\(String(indexPath.row + 1 - howManyItemsShouldIAdd))"
                print(appointlist.contains(ymd))
                if(appointlist.contains(ymd)){
                  
                    if(appointState[ymd] == "Waiting Confirm"){
                        textLabel.textColor = .blue
                    }else if(appointState[ymd] == "Confirmed"){
                        textLabel.textColor = .green
                    }else if(appointState[ymd] == "Denied"){
                        textLabel.textColor = .purple
                    }else if(appointState[ymd] == "Cancelling"){
                        textLabel.textColor = .orange
                    }else if(appointState[ymd] == "Cancelled"){
                        textLabel.textColor = .red
                    }
                    
                }
                
            }
        }
        /*
        if let textLabel = cell.contentView.subviews[0] as? UIButton{
            textLabel.isEnabled = false
            
            if indexPath.row < howManyItemsShouldIAdd{
                textLabel.setTitle("", for: .normal)
                textLabel.backgroundColor = .gray
            }else{
                textLabel.setTitle("\(indexPath.row + 1 - howManyItemsShouldIAdd)", for: .normal)
                textLabel.backgroundColor = .white
                
                if ((textLabel.currentTitle == String(currentDay)) && (curr == ymd)){
                    textLabel.backgroundColor = UIColor(red:0.70, green:0.92, blue:0.96, alpha:1.0)
                }else{
                    textLabel.setTitleColor(.black, for: .normal)
                }
                 let ymd = "\(String(currentYear))-\(String(currentMonth))-\(String(indexPath.row + 1 - howManyItemsShouldIAdd))"
                print(appointlist.contains(ymd))
                if(appointlist.contains(ymd)){
                    textLabel.isEnabled = true
                    if(appointState[ymd] == "Waiting Confirm"){
                        textLabel.setTitleColor(.blue, for: .normal)
                    }else if(appointState[ymd] == "Confirmed"){
                        textLabel.setTitleColor(.green, for: .normal)
                    }else if(appointState[ymd] == "Denied"){
                        textLabel.setTitleColor(.purple, for: .normal)
                    }else if(appointState[ymd] == "Cancelling"){
                        textLabel.setTitleColor(.orange, for: .normal)
                    }else if(appointState[ymd] == "Cancelled"){
                        textLabel.setTitleColor(.red, for: .normal)
                    }
                    
                }
                
            }
        }
        */
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // currentYear currentMonth day = (indexPath.row + 1 - howManyItemsShouldIAdd)
        
        items.removeAll()
        var didchange = false
        do{
            appoint = try context.fetch(Appointment.fetchRequest())
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if appoint.count > 0{
                for app in appoint{
                    
                    
                    let appdate = formatter.string(from: app.date!)
                    
                    if (appdate == "\(String(currentYear))-\(String(currentMonth))-\(String(indexPath.row + 1 - howManyItemsShouldIAdd))"){
                        let str = "\(app.detail!)  \(app.status!)"
                        items.append(str)
                        didchange = true
                    }
                    
                    appointState[appdate] = app.status
                }
            }
            
            appointlist = Array(appointState.keys)
            

        }catch{}
        
        if (didchange){
            
            appointmentTable.reloadData()
        }else{
            let itemsObject = UserDefaults.standard.object(forKey: "items")
            
            if let tempItems = itemsObject as? [String]{
                
                items = tempItems
            }
            appointmentTable.reloadData()
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: 40)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendar.collectionViewLayout.invalidateLayout()
        calendar.reloadData()
    }
    
    var howManyItemsShouldIAdd:Int{
        return whatDayIsIt - 1
    }
    
    var whatDayIsIt:Int{
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUp()
        
        
        
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
    
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
    }
    
    
    func findApp(){
        do{
            appoint = try context.fetch(Appointment.fetchRequest())
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if appoint.count > 0{
                for app in appoint{
                    
                    let appdate = formatter.string(from: app.date!)
                    appointState[appdate] = app.status
                }
            }
            
            appointlist = Array(appointState.keys)
            
            print(appointState)
            print(appointlist)
        }catch{}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        print(sender)
        
        
        if sender as! UIBarButtonItem == appointBar {
            let appoint:AppointmentViewController = segue.destination as! AppointmentViewController
            appoint.mqttClient = mqttClient
        }
        //else if sender as! UIButton ==  {
            
        //}
       
        
        
    }
    
    func mqtt_config()
    {
        mqttClient.didConnectAck = { mqtt, ack in
            if ack == .accept
            {
                
                mqtt.subscribe("ReservationConfirm", qos: CocoaMQTTQOS.qos2)
                mqtt.subscribe("`", qos: CocoaMQTTQOS.qos2)
            }
        }
        
        mqttClient.connect()
    }

    
    
    func setUp(){
        timeLabel.text = months[currentMonth - 1] + " \(currentYear)"
        calendar.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mqttClient.didReceiveMessage = { mqtt, message, id in
            self.audioPlayer.play()
            
            if message.topic == "ReservationConfirm"
            {
                let data = message.string!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                print("get1")
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                     print("get2")
                    if let name = json["patient_name"], let date = json["Date"], let id = json["appointID"], let detail = json["Reason"], let status = json["appointStatus"]
                    {
                        print("get3")
                        do{
                            let fetchRequest : NSFetchRequest<Appointment> = Appointment.fetchRequest()
                            fetchRequest.predicate = NSPredicate(format:"detail == %@", detail as! CVarArg)
                            self.appoint = try self.context.fetch(fetchRequest)
                            
                            for app in self.appoint{
                                app.id = String(describing: id)
                                app.status = String(describing: status)
                            }
                            // alert
                            let alert = UIAlertController(title: "Reservation Revised", message: "Date:\(date) \nPatient Name: \(name) \nDetails: \(detail) \nStatus:\(status)", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Close",style: .default, handler:{(action: UIAlertAction!) in print()}))
                            
                            // show the number on label
                            self.present(alert,animated: true, completion: nil)
                        }catch{}
                        self.calendar.reloadData()
                    }
                        /*
                         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                         let reserve = Reserves(context: context)
                         reserve.patient_name = String(describing: name)
                         reserve.patient_age = String(describing: age)
                         reserve.patient_sex = String(describing: sex)
                         reserve.patient_No = String(describing: num)
                         reserve.reserve_date = String(describing: date)
                         
                         //(UIApplication.shared.delegate as! AppDelegate).saveContext()
                         
                         //self.reserveTableView.reloadData()
                         
                         
                         self.patientNumberLabel.text = String(describing: num)
                         self.patientNumberLabel.textColor = UIColor.blue
                         self.patientNumberLabel.blink()
                         
                         // enable the qrcode button
                         self.QRCodeButton.isHidden = false
                         */
                       
                    
                } catch let error as NSError
                {
                        print("Failed to load: \(error.localizedDescription)")
                        
                }
            }
                
                /*
                 {
                 "patient_age": "67",
                 "patient_sex": "Male",
                 "patient_name": "nh",
                 "patient_No":"365"
                 }
                 */
                
        }
            
        
    }

}
