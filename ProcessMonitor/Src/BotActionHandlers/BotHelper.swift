//
//  BotHelper.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/26/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import ApiAI

class HelperActionHandler {
    
    func getAllCongifuredMonitoringSystems (Params: [String: AIResponseParameter]){
        print("Inside getAllCongifuredMonitoringSystems")
        var responseString = ""
        responseString = "I am configured to monitor following systems.\n GCLR. \n Fails. \n OMAR. \n Optmizer. \n and TRAM.\n If you want to configure more, please contact - UniConsole Admin"
        
        GLOBAL_notifyToViews(notificationMsg: responseString, notificationType: NotificationTypes.ANSWER)
        SpeakMessage.instance.speak(speakString: responseString)
    }
    
    func getAllHelpCommands (Params: [String: AIResponseParameter]){
        print("Inside getAllHelpCommands")
        var responseString = ""
        responseString = "You can ask me questions like\n What are the systems that you monitor?\n Where is OMAR running in PROD?\n What are the top 5 memory intense systems?\n How much CPU is consumed by Balance Sever?"
        
        GLOBAL_notifyToViews(notificationMsg: responseString, notificationType: NotificationTypes.ANSWER)
        SpeakMessage.instance.speak(speakString: responseString)
    }
    
}
