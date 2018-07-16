//
//  AWSResponseHandler.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 2/5/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation

class AWSResponseHandler{
    func getProcessOnBox(AWSResponse:[String:Any]) {
        print("inside AWSResponseHandler::getProcessOnBox")
        var respponseStr = ""
        respponseStr = AWSResponse["PROCESS_NAME"] as! String
        respponseStr += " runs on "
        respponseStr += AWSResponse["BOX"] as! String
        respponseStr += "."

        print("respponseStr = \(respponseStr)")
        
        CommunicateBackToGUI(respponseStr: respponseStr)
    }
    
    func getProcessStatusAndScheduleDetails(AWSResponse:[String:Any]) {
        print("inside AWSResponseHandler::getProcessStatusAndScheduleDetails")
        var respponseStr = ""
        respponseStr = AWSResponse["PROCESS_NAME"] as! String
        respponseStr += " runs on "
        respponseStr += AWSResponse["BOX"] as! String
        respponseStr += ". It's current status is "
        respponseStr += AWSResponse["CURRENT_STATUS"] as! String
        CommunicateBackToGUI(respponseStr: respponseStr)
    }
    
    func getBoxCpuAndMemUsage(AWSResponse:[String:Any]) {
        print("inside AWSResponseHandler::getBoxCpuAndMemUsage")
        var respponseStr = ""
        respponseStr = "On Machine: "
        respponseStr += AWSResponse["BOX"] as! String
        respponseStr += ".\n\t Total Memory Used is "
        respponseStr += AWSResponse["BOX_MEMORY_USED"] as! String
        respponseStr += ".\n\t Available Free Memory is "
        respponseStr += AWSResponse["BOX_MEMORY_FREE"] as! String
        respponseStr += ".\n\t Total CPU consumption is "
        respponseStr += AWSResponse["BOX_CUP"] as! String
        CommunicateBackToGUI(respponseStr: respponseStr)
    }
    
    func getCounterpartyExposure(AWSResponse:[String:Any]) {
        print("inside AWSResponseHandler::getCounterpartyExposure")
        var respponseStr = ""
        respponseStr = "Exposure with  "
        respponseStr += AWSResponse["COUNTERPARTY_NAME"] as! String
        respponseStr += " is $ "
        respponseStr += AWSResponse["COUNTERPARTY_EXPOSURE"] as! String
        respponseStr += "."
        CommunicateBackToGUI(respponseStr: respponseStr)
    }
    
    func getTopCounterpartyExposure(AWSResponse:[String:Any]) {
        print("inside AWSResponseHandler::getTopCounterpartyExposure")
        var respponseStr = ""
        respponseStr = "The top "
        respponseStr += AWSResponse["TOP_N"] as! String
        respponseStr += " Counterpary Exposure is "
        respponseStr += AWSResponse["COUNTERPARTY_EXPOSURE"] as! String
        respponseStr += "."
        CommunicateBackToGUI(respponseStr: respponseStr)
    }
    
    func getTopMemoryConsumptionProcess(AWSResponse:[String:Any]) {
        print("inside AWSResponseHandler::getTopCounterpartyExposure")
        var respponseStr = ""
        respponseStr = "The top "
        respponseStr += AWSResponse["TOP_N"] as! String
        respponseStr += " Memory consumers is/are "
        respponseStr += AWSResponse["MEMORY_CONSUMPTION"] as! String
        respponseStr += "."
        CommunicateBackToGUI(respponseStr: respponseStr)
    }
    
    func getAllRunningProcessOnHost(AWSResponse:[String:Any]) {
        print("inside AWSResponseHandler::getProcessOnHost")
        var respponseStr = ""
        respponseStr = "Following process run on  "
        respponseStr += AWSResponse["HOST_NAME"] as! String
        respponseStr += ": "
        respponseStr += AWSResponse["ALL_RUNNING_PROCESS"] as! String
        respponseStr += "."
        CommunicateBackToGUI(respponseStr: respponseStr)
    }
    
    func CommunicateBackToGUI(respponseStr: String){
        DispatchQueue.main.async {
        
        GLOBAL_notifyToViews(notificationMsg: respponseStr, notificationType: NotificationTypes.ANSWER)
        
        SpeakMessage.instance.speak(speakString: respponseStr)
        
        }
        
    }
}
