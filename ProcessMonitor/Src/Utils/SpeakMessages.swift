//
//  SpeakMessages.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/11/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import AVFoundation

class SpeakMessage: NSObject,AVSpeechSynthesizerDelegate {
    static let instance = SpeakMessage()
    
    let synthesizer = AVSpeechSynthesizer()
    let audioSession = AVAudioSession.sharedInstance()
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(speakString:String){
        if(!GLOBAL_IS_MUTE_MODE) {
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
                
                let utterance       = AVSpeechUtterance(string: speakString)
                let speakerLang     = GLOBAL_SPEAK_LANGUAGE
                utterance.voice     = AVSpeechSynthesisVoice(language: speakerLang)
                
                try audioSession.setActive(true)
                
                synthesizer.speak(utterance)
                
            } catch {
                
                NSLog("Error while setting up audio framework")
            }
        }
    }
    
    func stopSpeaking() {
        do {
            try audioSession.setActive(false)
        }
        catch {
            NSLog("Exception in stopSpeaking ")
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        do {
            try audioSession.setActive(false)
        }
        catch {
            NSLog("Exception in speechSynthesizer - didFinish utterance")
        }
    }
    
}
