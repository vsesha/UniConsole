//
//  GlobalFunctions.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/20/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
func GLOBAL_notifyToViews(notificationMsg:String, notificationType:NotificationTypes){
    
    let msg                 = notificationMsg
    
    var msgObj              = NotificationMessage()
    
    msgObj.NotifyType       = notificationType
    
    msgObj.NotifyMessage    = msg

    NotificationCenter.default.post(name: Notification.Name(rawValue: GLOBAL_APP_INTERNAL_NOTIFICATION_KEY),
                                    object: msgObj)
}


func stripOffUnwantedCharaters(dirtyString: String) -> String {
    var cleanString  = dirtyString.uppercased()
    
    cleanString = cleanString.trimmingCharacters(in: .whitespacesAndNewlines)
    cleanString = cleanString.removingWhitespaces()
    cleanString = cleanString.removingNewLineCharacters()
    
    cleanString = cleanString.replacingOccurrences(of: "(", with: "")
    cleanString = cleanString.replacingOccurrences(of: ")", with: "")
    
    return cleanString
}
