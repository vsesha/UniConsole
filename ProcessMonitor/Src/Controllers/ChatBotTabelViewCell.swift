//
//  ChatBotTabelViewCell.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 7/19/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import UIKit

protocol ChatBotTabelViewCellDelegate: class {
    func deleteRow (sender: ChatBotTabelViewCell)
    func shareRowData (sender: ChatBotTabelViewCell)
}

class ChatBotTabelViewCell: UITableViewCell {

    @IBOutlet weak var s_AssistantLabel:    UILabel!
    @IBOutlet weak var s_botResponse:       UILabel!
    @IBOutlet weak var s_ChartButton:       UIButton!
    @IBOutlet weak var s_YouLabel:          UILabel!
    @IBOutlet weak var s_UserQuestion:      UILabel!

    weak var delegate: ChatBotTabelViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        InitilizeControls()
        decorateControls()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func InitilizeControls(){
        s_botResponse.text = "How can I help you?"
        s_ChartButton.isHidden  = true
        //s_YouLabel.isHidden     = true
        //s_UserQuestion.isHidden = true
        
    }
    
    func decorateControls(){
        s_botResponse.layer.shadowOpacity = 0.4
        s_botResponse.layer.shadowOffset = CGSizeFromString("1")
        s_botResponse.layer.shadowRadius = 4
        s_botResponse.layer.masksToBounds = true
        s_botResponse.layer.cornerRadius = 6
       
        
        s_UserQuestion.layer.shadowOpacity = 0.4
        s_UserQuestion.layer.shadowOffset = CGSizeFromString("1")
        s_UserQuestion.layer.shadowRadius = 4
        s_UserQuestion.layer.masksToBounds = true
        s_UserQuestion.layer.cornerRadius = 6
    }
    
    @IBAction func DeleteThisRow(_ sender: UIButton) {
        delegate?.deleteRow(sender: self)
    }
    
    @IBAction func shareThisRow(_ sender: UIButton) {
        delegate?.shareRowData(sender: self)
    }
    
    
}
