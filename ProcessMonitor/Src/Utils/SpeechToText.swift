//
//  SpeechToText.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/11/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import UIKit
import Speech


class SpeechController:  NSObject, SFSpeechRecognizerDelegate {
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    override init() {
        super.init()
        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            var msgToUser = ""
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                msgToUser = "User denied access to speech recognition"
                
            case .restricted:
                isButtonEnabled = false
                msgToUser = "Speech recognition restricted on this device"
                
            case .notDetermined:
                isButtonEnabled = false
                msgToUser = "Speech recognition not yet authorized"
            }
        
            if(!isButtonEnabled)
            {
                print(msgToUser)
            }
        }
    }
    
    
    
    func startRecording(labelControl: UITextField) {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        AudioServicesPlaySystemSound(1519)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        let inputNode = audioEngine.inputNode /* {fatalError("Audio engine has no input node")}  //4*/
        
        
        guard let recognitionRequest = recognitionRequest else {fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")} //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
                labelControl.text = result?.bestTranscription.formattedString  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                //self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("speechRecognizer is Available")
        } else {
            print("speechRecognizer is NOT Available")
        }
    }
    
    func stopSpeaking(){
        AudioServicesPlaySystemSound(1520)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        }catch {
            print("audioSession properties weren't set because of an error.")
        }
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
}
