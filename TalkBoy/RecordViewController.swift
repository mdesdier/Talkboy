//
//  RecordViewController.swift
//  TalkBoy
//
//  Created by tester on 11/19/18.
//  Copyright © 2018 Tepo Labs. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {

    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var MessageText: UITextField!

    var audioRecorder : AVAudioRecorder?  //make optional and leave empty for now
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?  // url to hold recording location
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //create audio session
        let session = AVAudioSession.sharedInstance()
        //session.setCategory(AVAudioSession.Category.playAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.setActive(true)
        
        //create url to save audio
        if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first  {
            let pathComponents = [basePath, "audio.m4a"]
            if let audioURL = NSURL.fileURL(withPathComponents: pathComponents) {
                self.audioURL = audioURL // save local audioURL to class var audioURL
                //create base path to documents directory
                
                //create some settings
                var settings : [String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44100.0
                settings[AVNumberOfChannelsKey] = 2
                //create the audio recorder
                
                audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
            }
        }
        
        PlayButton.isEnabled = false    //play button initially grayed out since nothing to play
        MessageText.isEnabled = false
        AddButton.isEnabled = false
    }
    

    @IBAction func RecordHit(_ sender: Any) {
        if let localAudioRecorder = self.audioRecorder {
            
            if localAudioRecorder.isRecording {
                localAudioRecorder.stop()
                RecordButton.setTitle("Record", for: .normal)  //change button to record since we hit stop
                
                PlayButton.isEnabled = true    //play button initially grayed out now enabled
                MessageText.isEnabled = true
                AddButton.isEnabled = true
                
            } else {
                localAudioRecorder.record()
                RecordButton.setTitle("Stop", for: .normal)
                
                PlayButton.isEnabled = false    //play button initially grayed out since nothing to play
                MessageText.isEnabled = false
                AddButton.isEnabled = false
            }
            
        }
    }
    
    @IBAction func PlayHit(_ sender: Any) {
        if let audioURL = self.audioURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        }
        
    }
    
    @IBAction func AddHit(_ sender: Any) {
        //as always get context for core data
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let sound = Sound(entity: Sound.entity(), insertInto: context) //Sound is name we gave to entity in xcdatamodeld
            sound.name = MessageText.text
            if let audioURL = self.audioURL {
                sound.audioData = try? Data(contentsOf: audioURL)
                try? context.save()
                navigationController?.popViewController(animated: true)
            }
        }
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
