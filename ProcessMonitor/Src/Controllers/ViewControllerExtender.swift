//
//  ViewControllerExtender.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 10/17/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//
import UIKit
import Foundation
extension ViewController: UITableViewDelegate, UITableViewDataSource, ChatBotTabelViewCellDelegate {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QnAArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatBotTableView.dequeueReusableCell(withIdentifier: "ChatBotTabelViewCell") as! ChatBotTabelViewCell
        var data:QnAStruct =  QnAArray[indexPath.row]
        cell.s_UserQuestion.text = data.questionText
        cell.s_botResponse.text  = data.AnswerText
        cell.s_ChartButton.isHidden = !(data.getHasChart())
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.QnAArray.remove(at: indexPath.row)
        self.ChatBotTableView.beginUpdates()
        self.ChatBotTableView.deleteRows(at: [indexPath], with: .automatic)
        self.ChatBotTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    
    func deleteRow(sender: ChatBotTabelViewCell) {
        let indexPath = self.ChatBotTableView.indexPath(for: sender)
        self.QnAArray.remove(at: (indexPath?.row)!)
        self.ChatBotTableView.beginUpdates()
        self.ChatBotTableView.deleteRows(at: [indexPath!], with: .automatic)
        self.ChatBotTableView.endUpdates()
    }

    
    func shareRowData(sender: ChatBotTabelViewCell) {
        let text = "sample text"
        
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    
}
