//
//  ViewController.swift
//  try3
//
//  Created by Kwong Hau Shing on 5/11/2018.
//  Copyright © 2018 Kwong Hau Shing. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if player?.rate == 0
        {
            playButton!.setTitle("Pause", for: UIControl.State.normal)
            player!.play()
            
        } else {
            playButton!.setTitle("Play", for: UIControl.State.normal)
            player!.pause()
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: "http://61.93.116.132:8080/music/Demons.m4a")
        playerItem = AVPlayerItem(url: url!)
        player=AVPlayer(playerItem: playerItem!)
        let playerLayer=AVPlayerLayer(player: player!)
 
    }


}

