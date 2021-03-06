//
//  BreakViewController.swift
//  Pomodoro
//
//  Created by Reno Valdes on 12/22/17.
//  Copyright © 2017 Reno Valdes. All rights reserved.
//

import UIKit
import AVFoundation

class BreakViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var seconds = 300 //Ths variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    var endSoundEffect: AVAudioPlayer?
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if(!isTimerRunning){
            runTimer()
            isTimerRunning = true
        }
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        timer.invalidate()
        self.seconds = 300
        isTimerRunning = false
        timerLabel.text = "05:00"
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: (#selector(WorkViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        self.seconds -= 1     //This will decrement(count down)the seconds.
        
        timerLabel.text = timeString(time: TimeInterval(self.seconds)) //This will update the label.
        
        if(self.seconds == 0){
            timer.invalidate()
            isTimerRunning = false
            
            let path = Bundle.main.path(forResource: "not-kiddin.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                endSoundEffect = try AVAudioPlayer(contentsOf: url)
                endSoundEffect?.play()
            } catch {
                // couldn't load file :(
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 6
        resetButton.layer.cornerRadius = 6
        
        startButton.frame = CGRect(x: 30, y: 30, width: 150, height: 150)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
