//
//  DetailsViewController.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 10/1/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import UIKit


class DetailsViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    

    

    struct dataFromPrev{
        var question:String
        var answer:String
        var additionalParams:String
    }
    var dataNode = dataFromPrev(question: "", answer: "", additionalParams: "")
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var frequencyType: UISwitch!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    var highFreqyencyValues = ["5 mins","10 mins","15 mins", "30 mins"]
    var midFrequencyValues = ["1 hour","2 hours","6 hours","12 hours","24 hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorateControls()
        questionLabel.text  = dataNode.question
        answerLabel.text    = dataNode.answer
        frequencyPicker.delegate    = self
        frequencyPicker.dataSource  = self
    }


    @IBAction func closeButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onChangeFrequency(_ sender: Any) {
        if(frequencyType.isOn) {
            frequencyLabel.text = "High frequently"
        } else
        {frequencyLabel.text = "Low frequency"}
        
        frequencyPicker.reloadAllComponents()
    }
    
    func decorateControls(){
        questionLabel.layer.shadowOpacity = 0.4
        questionLabel.layer.shadowOffset = CGSizeFromString("2")
        questionLabel.layer.shadowRadius = 4
        questionLabel.layer.masksToBounds = false
        questionLabel.layer.cornerRadius = 4
        
        answerLabel.layer.shadowOpacity = 0.4
        answerLabel.layer.shadowOffset = CGSizeFromString("2")
        answerLabel.layer.shadowRadius = 6
        answerLabel.layer.masksToBounds = false
        answerLabel.layer.cornerRadius = 6
        
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(frequencyType.isOn) {
            return highFreqyencyValues.count }
        else{return midFrequencyValues.count}
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(frequencyType.isOn) {
            return highFreqyencyValues[row]
        }else {return midFrequencyValues[row]}
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            pickerLabel?.textAlignment = .center
        }
        
        
        if(frequencyType.isOn) {
            pickerLabel?.text = highFreqyencyValues[row]
            pickerLabel?.textColor = UIColor.red
        }
        else {pickerLabel?.text = midFrequencyValues[row]
            pickerLabel?.textColor = UIColor.blue}
        
        return pickerLabel!
    }
    
    
    
}
