//
//  BotActions.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/12/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import ApiAI

class BotActionHandlerManager {

    func actionHandler (Response: String, ActionString: String, Parameters: [String: AIResponseParameter]){
         GLOBAL_notifyToViews(notificationMsg: "0.5", notificationType: NotificationTypes.PROGRESS_BAR_UPDATE )
        switch (ActionString){
        
        case "ACTION.GET_ALL_HELP_COMMANDS":
            let botHelper = HelperActionHandler()
            botHelper.getAllHelpCommands (Params: Parameters)
            break
            
        case "ACTION.GET_ALL_CONFIGURED_MONITORING_SYSTEMS":
            let botHelper = HelperActionHandler()
            botHelper.getAllCongifuredMonitoringSystems(Params: Parameters)
            break
            
        case "ACTION.GET_PROCESS_ON_BOX":
            let processHandl = ProcessHandler()
            processHandl.getProcessOnBox(Params: Parameters)
            break
        
        case "ACTION.GET_PROCESS_STATUS_AND_SCHEDULE":
            let processHandl = ProcessHandler()
            processHandl.getProcessStatusAndScheduleDetails(Params: Parameters)
            break
  
        case "ACTION.GET_BOX_HEALTH":
            let boxHealth = BoxHealthCpuAndMemoryHandler()
            boxHealth.getBoxCpuAndMemUsage(Params: Parameters)
            
            
        case "ACTION.CONTEXT_EXPIRED":
            processExpiredActionContext()
            break
            
        case "ACTION.BUSINESS_COUNTERPARTY_EXPOSURE":
            let businessHandler = BusinessActionHandler()
            businessHandler.getCounterpartyExposure(Params: Parameters)
            break
            
        case "ACTION.BUSINESS_TOP_N_COUNTERPARTY_EXPOSURE":
            let businessHandler = BusinessActionHandler()
            businessHandler.getTopCounterpartyExposure(Params: Parameters)
            break
        
        case "ACTION.GET_TOP_MEMORY_INTENSE_PROCESS":
            let infraHandler = InfrastructureActionHandler()
            infraHandler.getTopMemoryConsumptionProcess(Params: Parameters)
            break
            
        case "ACTION.GET_PROCESS_ON_HOST":
            let infraHandler = InfrastructureActionHandler()
            infraHandler.getAllRunningProcessOnHost (Params: Parameters)
            break
            
        default:
            print("No handlered defined for  \(ActionString)")
            
        }
    }
    func processExpiredActionContext(){
        print("inside processExpiredActionContext")
        
        var responseString = ""
        responseString = "Hmm, looks like your previous context is expired or I lost your question. Could you please repeat your question with context?"
        GLOBAL_notifyToViews(notificationMsg: responseString, notificationType: NotificationTypes.ANSWER)
        SpeakMessage.instance.speak(speakString: responseString)
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func removingNewLineCharacters() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    
    
}
