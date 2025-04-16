//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes = ["Soft": 3, "Medium": 4, "Hard": 7]
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer?
    var timer = Timer()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eggProgress: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        eggProgress.progress = 0.0
        secondsPassed = 0
        
        timer.invalidate()
        
        guard let hardness = sender.titleLabel?.text else {
            return;
        }
        
        titleLabel.text = hardness
        
        guard let result = eggTimes[hardness] else {
            return;
        }
        
        
        totalTime = result
        
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    @objc func updateCounter() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            let porcentageProgress = Float(secondsPassed) / Float(totalTime)
            eggProgress.progress = porcentageProgress
            
        } else {
            timer.invalidate()
            playSound()
            titleLabel.text = "DONE!"
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3" ) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
