//
//  BotCommunication.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/12/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import ApiAI


class BotCommunicationManager: NSObject{
    var botactionHandler = BotActionHandlerManager()
    override init () {
        super.init()
    }
    
    func sendRequestToProcessManagerBOT(queryString: String, botResponseLabel: UITextView) throws   {
        do {
                let request = ApiAI.shared().textRequest()
                request?.query  = queryString
                request?.setMappedCompletionBlockSuccess({ (request, response) in
                let response        = response as! AIResponse
                
                if (!response.status.isSuccess){
                    let errMsg = "Error: \(response.status.error)"
                    
                    var respMsg = "Status for " + queryString
                    respMsg += "  resulted with " + errMsg
                    
                    botResponseLabel.text = respMsg
                    return
                }
                
                let BotResult       = response.result
                    
                let actionInComplete = BotResult?.actionIncomplete

                    
                let BotResponse     = BotResult?.fulfillment.speech
                var parameters      = BotResult?.parameters as? [String: AIResponseParameter]
                print ("Parameters = \(parameters)")
                
                var action          = BotResult?.action as! String
                
                if (action == "ACTION.PREVIOUS_CONTEXT"){
                    let PrevContext         = response.result.contexts as! [AIResponseContext]
                    if (PrevContext.count>0){
                        let prevParameter = PrevContext[0].parameters
                        parameters = prevParameter as! [String : AIResponseParameter]
                        //action = parameters["my-action"]?.
                        action = stripOffUnwantedCharaters(dirtyString: (parameters!["ACTION_FOR_CONTEXT"]?.stringValue)!)
                        //action = "ACTION.GET_PROCESS_ON_BOX"
                        
                    } else {
                        action = "ACTION.CONTEXT_EXPIRED"
                    }
                }
                SpeakMessage.instance.speak(speakString: BotResponse!)
                    
                botResponseLabel.text = botResponseLabel.text + "\n"
                botResponseLabel.text = botResponseLabel.text + BotResponse!
                
                GLOBAL_notifyToViews(notificationMsg: "0.4", notificationType: NotificationTypes.PROGRESS_BAR_UPDATE )
                    if(actionInComplete == 0){
                        self.botactionHandler.actionHandler ( Response: BotResponse!,
                                                      ActionString: action,
                                                      Parameters: parameters!)
                        
                    }
                
            }, failure: { (request, error) in
                print("error = \(error)")
            })
            try  ApiAI.shared().enqueue(request)
        }
    }
    
    
    
    func sendRequestToProcessManagerBOT_new(queryString: String, completion: @escaping ( String)->()) throws   {
        do {
            let request = ApiAI.shared().textRequest()
            
            request?.query  = queryString
            request?.setMappedCompletionBlockSuccess({ (request, response) in
                let response        = response as! AIResponse
                
                if (!response.status.isSuccess){
                    let errMsg = "Error: \(response.status.error)"
                    
                    var respMsg = "Status for " + queryString
                    respMsg += "  resulted with " + errMsg
                    
                    //responseFromBot  = respMsg
                    completion(respMsg)
                    return
                }
                
                let BotResult       = response.result
                
                let actionInComplete = BotResult?.actionIncomplete
                
                
                let BotResponse     = BotResult?.fulfillment.speech
                var parameters      = BotResult?.parameters as? [String: AIResponseParameter]
                print ("Parameters = \(parameters)")
                
                var action          = BotResult?.action as! String
                
                if (action == "ACTION.PREVIOUS_CONTEXT"){
                    let PrevContext         = response.result.contexts as! [AIResponseContext]
                    if (PrevContext.count>0){
                        let prevParameter = PrevContext[0].parameters
                        parameters = prevParameter as! [String : AIResponseParameter]
                        //action = parameters["my-action"]?.
                        action = stripOffUnwantedCharaters(dirtyString: (parameters!["ACTION_FOR_CONTEXT"]?.stringValue)!)
                        //action = "ACTION.GET_PROCESS_ON_BOX"
                        
                    } else {
                        action = "ACTION.CONTEXT_EXPIRED"
                    }
                }
                SpeakMessage.instance.speak(speakString: BotResponse!)
                
                completion(BotResponse!)
                //botResponseLabel.text = botResponseLabel.text + "\n"
                //botResponseLabel.text = botResponseLabel.text + BotResponse!
                
                //GLOBAL_notifyToViews(notificationMsg: "0.4", notificationType: NotificationTypes.PROGRESS_BAR_UPDATE )
                
                if(actionInComplete == 0){
                    self.botactionHandler.actionHandler ( Response: BotResponse!,
                                                          ActionString: action,
                                                          Parameters: parameters!)
                    
                }
                
            }, failure: { (request, error) in
                print("error = \(error)")
            })
            try  ApiAI.shared().enqueue(request)
        }
    }
}
