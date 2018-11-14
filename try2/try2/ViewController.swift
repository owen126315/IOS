//
//  ViewController.swift
//  try2
//
//  Created by Kwong Hau Shing on 2/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var buttonLabel: UIButton!
    @IBOutlet var myTableView: UITableView!
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var numberOfRecordes = 0
    
    @IBAction func record(_ sender: Any) {
        //check if we have active recorder
        if audioRecorder == nil {
            numberOfRecordes += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecordes).m4a")
            let setting = [AVFormatIDKey:Int(kAudioFormatMPEG4AAC), AVSampleRateKey:12000, AVNumberOfChannelsKey:1, AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue]
            
            //start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: setting )
                audioRecorder.delegate = self
                audioRecorder.record()
                buttonLabel.setTitle("stop recording", for: .normal)
            }
            catch {
                displayAlert(title: "Error", message: "Recording Fail")
            }
        }
        else {
            //stop recording
            audioRecorder.stop()
            audioRecorder = nil
            UserDefaults.standard.set(numberOfRecordes, forKey: "myNumber")
            myTableView.reloadData()
            buttonLabel.setTitle("Record", for: .normal)
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Setting up session
        recordingSession = AVAudioSession.sharedInstance()
        if let number = UserDefaults.standard.object(forKey: "myNumber") as? Int {
            numberOfRecordes = number
        }
    AVAudioSession.sharedInstance().requestRecordPermission{(hasPermission) in
            if hasPermission {
                print("accepted")
            }
            
        }
    }

//function get path to the directory
    func getDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
    
    //function display alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction( title: "dismiss ", style: .default, handler: nil ))
        present(alert, animated: true, completion: nil)
    }
    
    //setting table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecordes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //playSound(soundURL: "http://61.93.116.132:8080/music/Demons.mp3")
        
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        }
        catch {
            
        }
        
    }
    
    func playSound(soundURL: String) {
        let sound = URL(string: soundURL)
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: sound!)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch let error {
            print("Errors:\(error.localizedDescription)")
        }
        
    }
}

